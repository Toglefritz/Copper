import 'package:copper_app/screens/home/home_route.dart';
import 'package:copper_app/screens/setup/setup_route.dart';
import 'package:flutter/material.dart';
import 'setup_view.dart';

/// Controller for the [SetupRoute].
class SetupController extends State<SetupRoute> {
  @override
  void initState() {
    // TODO(Toglefritz): Check if existing project is available
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigateToHome());

    super.initState();
  }

  /// Navigates to the home screen.
  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (context) => const HomeRoute()),
    );
  }

  @override
  Widget build(BuildContext context) => SetupView(this);
}
