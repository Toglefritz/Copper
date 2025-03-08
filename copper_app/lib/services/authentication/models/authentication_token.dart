
import 'package:copper_app/services/authentication/models/id_token.dart';

/// Represents an access token obtained from authentication against the SSO system.
class AuthenticationToken {
  /// The requested access token. The app can use this token to authenticate to the secured resource, such as a web API.
  final String token;

  /// Indicates the token type value. The only type that Microsoft Entra ID supports is `Bearer`.
  final String tokenType;

  /// How long the access token is valid, in seconds.
  final int? expiresIn;

  /// A timestamp for when the token expires. This information is not directly included in the token itself. Instead, it
  /// is calculated based on the current time and the [expiresIn] value based on when the token was received.
  final DateTime expiresAt;

  /// The scopes for which the [token] provides valid access. Separate scopes are separated by spaces.
  final String scopes;

  /// An OAuth 2.0 refresh token. The app can use this token to acquire other access tokens after the current access token
  /// expires. Refresh tokens are long-lived. They can maintain access to resources for extended periods.
  final String refreshToken;

  /// A JSON Web Token (JWT). The app can decode the segments of this token to request information about the user who
  /// signed in.
  final IdToken idToken;

  /// The raw ID token string.
  final String rawIdToken;

  /// Initializes a new instance of the [AuthenticationToken] class.
  AuthenticationToken({
    required this.token,
    required this.tokenType,
    required this.expiresIn,
    required this.expiresAt,
    required this.scopes,
    required this.refreshToken,
    required this.idToken,
    required this.rawIdToken,
  });

  /// Creates a new instance of the [AuthenticationToken] class from a JSON object.
  factory AuthenticationToken.fromJson(Map<String, dynamic> json) {
    /// Calculate the time at which the token expires.
    final int? expiresIn = json['expires_in'] as int?;
    // If the "expires_in" property is not present in the JSON object, the token is assumed to be expired already.
    final DateTime expiresAt = DateTime.now().add(Duration(seconds: expiresIn ?? 0));

    // Get an IdToken from the "id_token" field.
    IdToken idToken;
    if (json['id_token'] is String) {
      idToken = IdToken.fromJwt(json['id_token'] as String);
    } else if (json['id_token'] is Map<String, dynamic>) {
      idToken = IdToken.fromJson(json['id_token'] as Map<String, dynamic>);
    } else {
      throw Exception('Failed to parse id_token');
    }

    return AuthenticationToken(
      token: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: expiresIn,
      expiresAt: expiresAt,
      scopes: json['scope'] as String,
      refreshToken: json['refresh_token'] as String,
      idToken: idToken,
      rawIdToken: json['id_token'] as String,
    );
  }

  /// Converts the [AuthenticationToken] instance to a JSON object.
  ///
  /// Returns a JSON object representing the [AuthenticationToken] instance. Note that the "expiresIn" property is not
  /// included in the JSON object. This is because, if a token is serialized to JSON and then deserialized at some
  /// arbitrary time in the future, the "expiresIn" value will be meaningless. Instead, the "expiresAt" property is
  /// included, which is a timestamp for when the token expires.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'access_token': token,
      'token_type': tokenType,
      // The "expires_in" property is not included and the "expires_at" property is included instead.
      'expires_at': expiresAt.toIso8601String(),
      'scope': scopes,
      'refresh_token': refreshToken,
      'id_token': idToken,
    };
  }

  /// Returns a representation of the token as a serialized JSON string.
  @override
  String toString() {
    return toJson().toString();
  }
}
