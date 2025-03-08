import 'package:copper_app/screens/onboarding/onboarding_route.dart';
import 'package:copper_app/services/authentication/authentication_service.dart';
import 'package:flutter/material.dart';
import 'onboarding_view.dart';

/// Controller for the [OnboardingRoute].
class OnboardingController extends State<OnboardingRoute> {
  /// Handles taps on the primary CTA button on the onboarding screen.
  ///
  /// Before the user can engage with this app, they must authenticate with the Copper system. This method is called
  /// when the user taps the primary CTA button on the onboarding screen. It triggers the authentication process.
  Future<void> handleOnboardingComplete() async {
    await AuthenticationService.authenticate();
  }

  @override
  Widget build(BuildContext context) => OnboardingView(this);
}
