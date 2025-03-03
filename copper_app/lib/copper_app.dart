import 'package:copper_app/screens/onboarding/onboarding_route.dart';
import 'package:copper_app/screens/setup/setup_route.dart';
import 'package:copper_app/services/authentication/authentication_service.dart';
import 'package:copper_app/services/authentication/models/user.dart';
import 'package:copper_app/theme/copper_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// The base application widget.
///
/// This widget is the root of the application. It returns a `MaterialApp` widget that is the base of the widget
/// tree for the application. It is within this `MateiralApp` widget that the application's theme is defined, along
/// with other properties that are used throughout the application.
class CopperApp extends StatelessWidget {
  /// Creates a new instance of the [CopperApp] widget.
  const CopperApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Copper',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: CopperAppTheme.lightTheme,
      darkTheme: CopperAppTheme.darkTheme,
      home: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: StreamBuilder<User?>(
          stream: AuthenticationService.authStateChanges,
          builder: (BuildContext context, AsyncSnapshot<User?> authStateSnapshot) {
            if (authStateSnapshot.hasData) {
              return const SetupRoute();
            } else {
              return const OnboardingRoute();
            }
          },
        ),
      ),
    );
  }
}
