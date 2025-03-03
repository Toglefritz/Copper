import 'package:copper_app/services/authentication/models/authentication_token.dart';

/// Represents the user of the Copper system authenticated with the app.
class User {
  /// The user's email address.
  final String email;

  /// The user's full name.
  final String name;

  /// Creates a new instance of the [User] class.
  User._({
    required this.email,
    required this.name,
  });

  /// Creates a new instance of the [User] class from an [AuthenticationToken] instance.
  factory User.fromToken(AuthenticationToken token) {
    return User._(
      email: token.idToken.email,
      name: token.idToken.name,
    );
  }
}
