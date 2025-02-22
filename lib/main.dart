import 'package:circuit_check_app/circuit_check_app.dart';
import 'package:flutter/material.dart';

/// The entry point of the application.
/// 
/// The [main] function initializes the app's core servies before running the [CircuitCheckApp] widget.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const CircuitCheckApp());
}
