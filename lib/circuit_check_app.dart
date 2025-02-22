import 'package:circuit_check_app/screens/setup/setup_route.dart';
import 'package:circuit_check_app/theme/circuit_check_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// The base application widget.
///
/// This widget is the root of the application. It returns a `MaterialApp` widget that is the base of the widget
/// tree for the application. It is within this `MateiralApp` widget that the application's theme is defined, along
/// with other properties that are used throughout the application.
class CircuitCheckApp extends StatelessWidget {
  /// Creates a new instance of the [CircuitCheckApp] widget.
  const CircuitCheckApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circuit Check',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: CircuitCheckAppTheme.lightTheme,
      darkTheme: CircuitCheckAppTheme.darkTheme,
      home: const SetupRoute(),
    );
  }
}
