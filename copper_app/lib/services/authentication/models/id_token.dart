
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

/// Represents the contents of an ID token obtained from authentication against the SSO system.
///
/// The ID token is a JWT containing information about the user and about the token itself. This class provides a
/// convenient way to access the claims within the token.
class IdToken {
  /// The audience for the token. This value is the App ID URI of the web API (secured resource) represented by the
  /// access token.
  final String aud;

  /// The issuer of the token. This value is the URL of the security token service (STS) that issued the token.
  final String iss;

  /// The timestamp for when the token was issued, represented as a Unix timestamp.
  final int iat;

  /// A "not valid before" timestamp for the token, represented as a Unix timestamp.
  final int nbf;

  /// The timestamp for when the token expires, represented as a Unix timestamp.
  final int exp;

  /// The user's email address.
  final String email;

  /// The user's full name.
  final String name;

  /// The subject of the token. This value is the unique identifier for the user.
  final String sub;

  /// Creates a new [IdToken] instance.
  IdToken({
    required this.aud,
    required this.iss,
    required this.iat,
    required this.nbf,
    required this.exp,
    required this.email,
    required this.name,
    required this.sub,
  });

  /// Accepts a JWT token as a String and returns an IdToken after parsing the JWT token.
  ///
  /// JWT tokens consist of a String value separated into three parts, divided by "." characters. So, this method
  /// starts by splitting the provided [token] argument by ".". The part of the JWT token of interest to the app,
  /// because it contains information about the user's account, is the second part. Therefore, the second
  /// component of the JWT token is converted to a JSON [Map]. If the second component of the JTW token fails
  /// to be converted into JSON format, this method throws an [Exception]. Otherwise, the `fromRegistrationInfo` method
  /// is called to return the resulting [IdToken] instance.
  factory IdToken.fromJwt(String token) {
    final JWT? jwtToken = JWT.tryDecode(token);

    if (jwtToken == null) {
      throw Exception('Failed to decode token');
    }

    // Return the IdToken from the JSON payload
    return IdToken.fromJson(jwtToken.payload as Map<String, dynamic>);
  }

  /// Accepts a JSON Map and returns an IdToken by referencing the keys within the JSON body.
  factory IdToken.fromJson(Map<String, dynamic> json) {
    return IdToken(
      aud: json['aud'] as String,
      iss: json['iss'] as String,
      iat: json['iat'] as int,
      nbf: json['nbf'] as int,
      exp: json['exp'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      sub: json['sub'] as String,
    );
  }

  /// Converts the [IdToken] instance to a JSON object.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'aud': aud,
      'iss': iss,
      'iat': iat,
      'nbf': nbf,
      'exp': exp,
      'email': email,
      'name': name,
      'sub': sub,
    };
  }
}
