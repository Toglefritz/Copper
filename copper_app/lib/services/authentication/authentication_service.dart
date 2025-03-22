import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:copper_app/services/authentication/models/auth_configuration.dart';
import 'package:copper_app/services/authentication/models/authentication_token.dart';
import 'package:copper_app/services/authentication/models/user.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web/web.dart' as web;

/// A service for authenticating users with Microsoft.
///
/// This application uses Microsoft's Azure Entra ID authentication system. This service provides methods for
/// managing authenticated sessions, including signing in and out, and listening for changes to the user's
/// authentication state.
///
/// ### Authentication Flow
///
/// The authentication flow implemented in this class follows the OAuth 2.0 authorization code grant flow:
///
/// 1. **Authorization Request**:
///    - The user is redirected to the SSO system's authorization endpoint. This presents the authentication form in a
///      separate browser window.
///    - The request includes the client ID, response type (code), redirect URI, response mode (query), and scope
///      (openid, profile, email, offline_access).
///
/// 2. **User Authentication**:
///    - The user authenticates with the SSO system (e.g., by entering their credentials).
///
/// 3. **Authorization Response**:
///    - After successful authentication, the SSO system redirects the user back to the Copper app with an authorization
///      code.
///
/// 4. **Token Request**:
///    - The app exchanges the authorization code for an access token by making a POST request to the authentication
///      system's token endpoint.
///    - The request includes the client ID, client secret, authorization code, redirect URI, grant type
///      (authorization_code), and scope.
///
/// 5. **Token Response**:
///    - The SSO system responds with an access token, which the app can use to access protected resources.
///
/// The TL;DR of this flow is that the user is presented with a separate browser window to authenticate with Microsoft.
/// After successful authentication, the app receives an access token that it can use to to get information about the
/// user and to include in backend API requests.
// ignore_for_file: invalid_runtime_check_with_js_interop_types
class AuthenticationService {
  /// A stream controller for the user's authentication state.
  static final StreamController<User?> _authStateController = StreamController<User?>.broadcast();

  /// This stream emits the current user's authentication state.
  ///
  /// The stream emits the current user's authentication state whenever it changes. The stream emits a `null` value
  /// if the user is not authenticated, and a [User] object if the user is authenticated. Other parts of the application
  /// can listen to this stream to respond to changes in the user's authentication state.
  static Stream<User?> get authStateChanges => _authStateController.stream;

  /// Cached information for the current authenticated session. Caching this information allows other parts of the app
  /// to synchronously access the user's information without waiting for the authentication service to fetch it. This
  /// is particularly important when the app sends REST API requests to backend services that require the user's
  /// authentication token.
  static AuthenticationToken? cachedToken;

  /// Initializes the authentication service.
  ///
  /// This method is called when the application starts. It checks if the user has a refresh token stored on the device.
  /// If a refresh token is found, the method attempts to refresh the user's access token. If the refresh is successful,
  /// the method emits the user's authentication state on the [authStateChanges] stream. If the refresh fails, the method
  /// emits a `null` value on the stream.
  static Future<void> initialize() async {
    // Attempt to get the refresh token from the device.
    final String? refreshToken = await _getRefreshToken();

    // If a refresh token is found, attempt to refresh the access token.
    if (refreshToken != null) {
      try {
        final AuthenticationToken authenticationTokens = await _refreshToken(refreshToken);

        // Create a user object from the token.
        final User user = await _getUser(authenticationTokens);

        // Cache the token for later use.
        cachedToken = authenticationTokens;

        // Emit the user object on the auth state stream.
        _authStateController.add(user);

      } catch (e) {
        debugPrint('Failed to refresh token: $e');

        _authStateController.add(null);
      }
    } else {
      _authStateController.add(null);
    }
  }

  /// Authenticates (signs in) the user with Microsoft.
  ///
  /// The process of authenticating the user with Entra ID involves three steps:
  ///
  /// 1. The user is redirected to Microsoft's authentication service to sign in. That service returns an authorization
  ///    code to the app.
  /// 2. The application sends the authorization code to Microsoft's authentication service to obtain an access token
  ///    and a refresh token.
  /// 3. The application uses the access token and refresh token to obtain information about the user and their
  ///    authenticated session.
  ///
  /// The access token obtained in this second step contains information about the user that is used to create the
  /// [User] object that represents the authenticated user. Additionally, this token is used to authenticate requests
  /// to various backend services.
  ///
  /// Alongside the access token, the app will also receive a refresh token. This token is used to obtain a new access
  /// token when the current one expires. The refresh token is stored securely on the device and is used to obtain a new
  /// access token without requiring the user to sign in again. In other words, the refresh token is used to maintain
  /// the user's authenticated session so they do not need to sign in again each time the app is used.
  static Future<void> authenticate() async {
    // Prerequisite: Generate a code verifier used as part of the OAuth 2.0 PKCE flow (explained in more detail below).
    final String codeVerifier = _generateCodeVerifier();

    // Step 1: Obtain an authorization code
    final String authorizationCode = await _getAuthorizationCode(codeVerifier);

    // Step 2: Obtain an access token
    final AuthenticationToken authenticationTokens = await _getToken(authorizationCode, codeVerifier);

    // Cache the token for later use.
    cachedToken = authenticationTokens;

    // Save the refresh token
    await _saveRefreshToken(authenticationTokens.refreshToken);

    // Step 3: Create a user object
    final User user = await _getUser(authenticationTokens);

    // Emit the user object on the auth state stream.
    _authStateController.add(user);
  }

  /// Performs authentication with the Sub-Zero Group Single Sign-On (SSO) system.
  ///
  /// Getting an authorization code from the SSO system is the first part of the process for ultimately obtaining an
  /// access token. The process of getting an authorization code involves two steps. First, the app sends a request to
  /// the SSO system's authorization endpoint, which includes the client ID, response type, redirect URI, response mode,
  /// and scope. The SSO system then authenticates the user and redirects them back to the app with an authorization code.
  ///
  /// ### Authorization Flows
  ///
  /// The authorization flow varies based on the platform on which the app is running:
  ///
  /// - **iOS and Android**:
  ///   - The app uses an Event Channel to listen for the redirect URI.
  ///   - The SSO system redirects the user to the app with an authorization code via a custom URL scheme.
  ///   - The app listens for the redirect URI and extracts the authorization code from the URI.
  ///
  /// - **Desktop (Windows and macOS)**:
  ///   - The app starts a local server to listen for the redirect URI.
  ///   - The SSO system redirects the user to the local server with an authorization code.
  ///   - The app extracts the authorization code from the URI received by the local server.
  ///
  /// - **Web**:
  ///   - The app opens the authentication URL in a new browser window.
  ///   - The SSO system redirects the user back to the app with an authorization code.
  ///   - The app listens for the redirect URI in the main window and extracts the authorization code from the URI.
  ///
  /// The function returns a `Future<String>` that completes with the authorization code.
  ///
  /// ### PKCE Flow
  ///
  /// This function implements the Proof Key for Code Exchange (PKCE) flow. PKCE is an extension to the OAuth 2.0
  /// authorization code grant flow that is designed to prevent certain attacks and to improve the security of the
  /// authorization code exchange. The PKCE flow involves generating a code verifier and a code challenge. The code
  /// verifier is a high-entropy cryptographic random string that is used to generate the code challenge. The code
  /// challenge is a Base64 URL-encoded SHA256 hash of the code verifier. The code challenge is sent to the SSO system
  /// in the authorization request, and the SSO system later uses it to verify the token request.
  static Future<String> _getAuthorizationCode(String codeVerifier) async {
    debugPrint('Getting authorization code...');

    // A Completer used to wait for the authorization code to be returned to the app via the redirect URI.
    final Completer<String> completer = Completer<String>();

    // Generate the code challenge for the PKCE flow.
    final String codeChallenge = _generateCodeChallenge(codeVerifier);

    // Build the URL for the SSO system.
    //
    // The URL includes the client ID, response type, redirect URI, response mode, and scope as path parameters.
    // Note that, for testing purposes, it is possible to copy this URL into a browser to manually authenticate.
    final Uri authUrl = Uri.https('login.microsoftonline.com', '/${AuthConfiguration.tenantId}/oauth2/v2.0/authorize', {
      'client_id': AuthConfiguration.clientId,
      'response_type': 'code',
      'redirect_uri': AuthConfiguration.redirectUri,
      'response_mode': 'query',
      'scope': 'openid profile email offline_access',
      'code_challenge': codeChallenge,
      'code_challenge_method': 'S256',
    });

    // Open the authentication URL in a new browser window.
    final web.Window? popup = web.window.open(authUrl.toString(), 'SSO Login');

    // Listen for messages from the browser window. After the user authenticates, the SSO system will redirect the user
    // back to the app with an authorization code. The app listens for the redirect URI and extracts the authorization
    // code from the URI.
    web.window.onMessage.listen((web.MessageEvent event) {
      if (event.data != null && event.data is String) {
        final Uri uri = Uri.parse(event.data! as String);
        if (uri.queryParameters.containsKey('code')) {
          debugPrint('Successfully received authorization code: ${uri.queryParameters['code']}');

          // Get the authorization code from the query parameters and complete the future.
          completer.complete(uri.queryParameters['code']);

          // Close the browser window.
          popup?.close();
        }
      }
    });

    // Wait for the authorization code.
    return completer.future;
  }

  /// Generates a code verifier for PKCE.
  ///
  /// The code verifier is a high-entropy cryptographic random string used in the PKCE flow. It is generated using a
  /// secure random number generator and is URL-safe. The code verifier is later used to generate a code challenge
  /// and must be kept secret.
  static String _generateCodeVerifier() {
    final Random random = Random.secure();
    final List<int> values = List<int>.generate(128, (i) => random.nextInt(256));

    return base64UrlEncode(values).replaceAll('=', '').replaceAll('+', '-').replaceAll('/', '_');
  }

  /// Generates a code challenge for PKCE.
  ///
  /// The code challenge is derived from the code verifier and is used in the authorization request.
  /// It is a Base64 URL-encoded SHA256 hash of the code verifier.
  /// The code challenge is sent to the authorization server, which will later use it to verify the token request.
  static String _generateCodeChallenge(String codeVerifier) {
    final List<int> bytes = utf8.encode(codeVerifier);
    final Digest digest = sha256.convert(bytes);

    return base64UrlEncode(digest.bytes).replaceAll('=', '').replaceAll('+', '-').replaceAll('/', '_');
  }

  /// Gets a token from the SSO system following successful authentication.
  static Future<AuthenticationToken> _getToken(String authorizationCode, String codeVerifier) async {
    debugPrint('Getting token...');

    try {
      // Build the URL for the SSO system.
      final Uri tokenUrl = Uri.https('login.microsoftonline.com', '/${AuthConfiguration.tenantId}/oauth2/v2.0/token');

      // Send a REST request to the SSO system to get a token.
      final Response response = await post(
        tokenUrl,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': AuthConfiguration.clientId,
          'scope': 'openid profile email offline_access',
          'code': authorizationCode,
          'redirect_uri': AuthConfiguration.redirectUri,
          'grant_type': 'authorization_code',
          'code_verifier': codeVerifier,
          'Origin': '*',
        },
      ).timeout(const Duration(seconds: 30));

      // Check for a successful response.
      if (response.statusCode == 200) {
        // Get the response body.
        final String responseBody = response.body;

        // Convert the response body to JSON.
        final Map<String, dynamic> json = jsonDecode(responseBody) as Map<String, dynamic>;

        // Create an access token from the JSON.
        final AuthenticationToken token = AuthenticationToken.fromJson(json);

        debugPrint('Successfully received ID token: ${token.rawIdToken}');
        debugPrint('Successfully received access token: ${token.token}');

        // Return the token.
        return token;
      } else {
        debugPrint('Failed to get token with status code, ${response.statusCode}, and message ${response.body}');

        throw Exception('Failed to get token with status code ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Failed to get token: $e');

      rethrow;
    }
  }

  /// Creates a [User] object from an [AuthenticationToken].
  static Future<User> _getUser(AuthenticationToken token) async {
    debugPrint('Getting user...');

    try {
      // Create a user object from the token.
      final User user = User.fromToken(token);

      debugPrint('Successfully received user: ${user.email}');

      return user;
    } catch (e) {
      debugPrint('Failed to get user: $e');

      rethrow;
    }
  }

  /// Saves the refresh token to the device.
  /// 
  /// The refresh token is used to obtain a new access token when the current one expires. The refresh token is stored
  /// securely on the device and is used to obtain a new access token without requiring the user to sign in again.
  static Future<void> _saveRefreshToken(String refreshToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh_token', refreshToken);
  }

  /// Gets the refresh token from the device.
  /// 
  /// The refresh token is used to obtain a new access token when the current one expires. The refresh token is stored
  /// securely on the device and is used to obtain a new access token without requiring the user to sign in again.
  static Future<String?> _getRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  /// Refreshes the access token using the refresh token.
  /// 
  /// To create a good user experience, this app has mechanisms in place allowing the user to remain authenticated
  /// with the app between sessions. This session persistence is managed by storing the refresh token obtained from
  /// authentication with Microsoft Entra ID. The refresh token can be used to obtain a new access token without
  /// requiring the user to sign in again. Therefore, by storing the refresh token, the app can maintain the user's
  /// authenticated session between app launches.
  /// 
  /// This method uses the refresh token to obtain a new access token. If the refresh is successful, the method returns
  /// the new access token. If the refresh fails, the method throws an exception.
  static Future<AuthenticationToken> _refreshToken(String refreshToken) async {
    debugPrint('Refreshing token...');

    try {
      // Build the URL for the SSO system.
      final Uri tokenUrl = Uri.https('login.microsoftonline.com', '/${AuthConfiguration.tenantId}/oauth2/v2.0/token');

      // Send a REST request to the SSO system to refresh the token.
      final Response response = await post(
        tokenUrl,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': AuthConfiguration.clientId,
          'scope': 'openid profile email offline_access',
          'refresh_token': refreshToken,
          'grant_type': 'refresh_token',
          'Origin': '*',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final String responseBody = response.body;
        final Map<String, dynamic> json = jsonDecode(responseBody) as Map<String, dynamic>;
        final AuthenticationToken token = AuthenticationToken.fromJson(json);

        debugPrint('Successfully refreshed ID token: ${token.rawIdToken}');
        debugPrint('Successfully refreshed access token: ${token.token}');

        return token;
      } else {
        debugPrint('Failed to refresh token with status code, ${response.statusCode}, and message ${response.body}');
        throw Exception('Failed to refresh token with status code ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Failed to refresh token: $e');
      rethrow;
    }
  }

  /// Signs out the user.
  Future<void> logout() async {
    debugPrint('Signing out...');

    // Clear the cached token.
    cachedToken = null;

    // Clear the refresh token from the device.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('refresh_token');

    // Emit a null value on the auth state stream to indicate that the user is signed out.
    _authStateController.add(null);

    // TODO(Toglefritz): Invalidate token via logout functionality in Azure
  }

  /// Dispose the StreamController when it is no longer needed.
  static void dispose() {
    _authStateController.close();
  }
}
