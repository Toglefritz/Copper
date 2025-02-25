import 'package:copper_app/copper_app.dart';
import 'package:flutter/material.dart';

/// The entry point of the application.
/// 
/// The [main] function initializes the app's core servies before running the [CopperApp] widget.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const CopperApp());
}
