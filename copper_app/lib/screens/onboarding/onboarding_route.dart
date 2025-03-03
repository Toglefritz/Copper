import 'package:copper_app/copper_app.dart';
import 'package:copper_app/screens/setup/setup_route.dart';
import 'package:copper_app/services/authentication/authentication_service.dart';
import 'package:flutter/material.dart';

import 'onboarding_controller.dart';

/// Displays an authentication form for the user to sign in or sign up.
/// 
/// This route is displayed if the user is not authenticated with the Copper system. It presents a form for the user to
/// either sign into an existing account or to create a new account.
/// 
/// This route does not perform navigation to a different route directly. Instead, the [AuthenticationService] exposes
/// a stream that emits the current user's authentication state. The [CopperApp] widget listens to this stream and
/// navigates to the [SetupRoute] if the user is authenticated, or to this route if the user is not authenticated.
class OnboardingRoute extends StatefulWidget {
  /// Creates an instance of [OnboardingRoute].
  const OnboardingRoute({super.key});

  @override
  State<OnboardingRoute> createState() => OnboardingController();
}
