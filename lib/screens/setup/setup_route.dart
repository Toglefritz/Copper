import 'package:flutter/material.dart';

import 'setup_controller.dart';

/// Performs the setup necessary to proceed to the next route. This involves getting a list of the user's devices,
/// assuming any have been added to the user's account, getting the details for each device, and handling errors
/// related to these processes.
class SetupRoute extends StatefulWidget {
  /// Creates an instance of [SetupRoute].
  const SetupRoute({super.key});

  @override
  State<SetupRoute> createState() => SetupController();
}
