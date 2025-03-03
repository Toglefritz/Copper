import 'package:copper_app/components/dotted_lines/dotted_outlined_border.dart';
import 'package:flutter/material.dart';

/// This class provides the theme for the Circuit Check app based on the current brightness. Static getters are provided
/// for both light and dark themes.
class CopperAppTheme {
  /// The light theme for the Circuit Check app.
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: Colors.grey[200]!,
          onPrimary: Colors.grey[900]!,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStateProperty.all<OutlinedBorder>(
              DottedOutlinedBorder(
                color: Colors.grey[200]!,
              ),
            ),
          ),
        ),
      );

  /// The dark theme for the Circuit Check app.
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.grey[900]!,
          onPrimary: Colors.grey[200]!,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStateProperty.all<OutlinedBorder>(
              DottedOutlinedBorder(
                color: Colors.grey[900]!,
              ),
            ),
          ),
        ),
      );
}
