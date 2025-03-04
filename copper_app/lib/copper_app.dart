import 'package:copper_app/components/loaders/pulsing_grid_loader.dart';
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
class CopperApp extends StatefulWidget {
  /// Creates a new instance of the [CopperApp] widget.
  const CopperApp({super.key});

  @override
  CopperAppState createState() => CopperAppState();
}

/// The state of the [CopperApp] widget.
/// 
/// On of the main purpose of this widget is to initialize the authentication service and check if the user is
/// authenticated. If the user is authenticated, the user is navigated to the [SetupRoute]. If the user is not
/// authenticated, the user is navigated to the [OnboardingRoute]. A loading indicator is displayed while the
/// application is checking the authentication state.
/// 
/// After the application launches, the user can become authenticated in two ways:
/// 
/// 1. The user is already authenticated and the application is able to retrieve the user's authentication state.
/// 2. The user is not authenticated and the user is navigated to the onboarding route where they can sign in or
///   create an account.
class CopperAppState extends State<CopperApp> {
  /// The future that initializes the authentication service.
  Future<void>? _initialization;

  @override
  void initState() {
    // Initialize the authentication service.
    _initialization = AuthenticationService.initialize();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
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
                // While the app is checking for an existing authentication state, display a loading indicator.
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          PulsingGridLoader(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (authStateSnapshot.hasData) {
                  return const SetupRoute();
                } else {
                  return const OnboardingRoute();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
