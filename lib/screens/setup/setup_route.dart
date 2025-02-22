import 'package:flutter/material.dart';

import 'setup_controller.dart';

/// Performs the setup necessary to proceed to the next route.
/// 
/// This route is displayed when the app is first opened. It checks if an existing project is available. If a 
/// project is available, the user is navigated to the project screen. If no project is available, the user is
/// navigated to the home screen.
class SetupRoute extends StatefulWidget {
  /// Creates an instance of [SetupRoute].
  const SetupRoute({super.key});

  @override
  State<SetupRoute> createState() => SetupController();
}
