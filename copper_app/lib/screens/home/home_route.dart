import 'package:flutter/material.dart';

import 'home_controller.dart';

/// The home screen of the app.
/// 
/// This screen displays an interface allowing the user to start a new project by submitting a PCB design file.
class HomeRoute extends StatefulWidget {
  /// Creates an instance of [HomeRoute].
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => HomeController();
}
