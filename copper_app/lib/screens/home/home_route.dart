import 'package:copper_app/services/kicad_parser/kicad_pcb_design.dart';
import 'package:flutter/material.dart';

import 'home_controller.dart';

/// The home screen of the app.
///
/// This screen displays an interface allowing the user to start a new project by submitting a PCB design file.
class HomeRoute extends StatefulWidget {
  /// Creates an instance of [HomeRoute].
  const HomeRoute({
    required this.designs, super.key,
  });

  /// A list of the user's past PCB design projects. These projects are retrieved from the Azure Cosmos DB backend
  /// resource.
  final List<KiCadPCBDesign> designs;

  @override
  State<HomeRoute> createState() => HomeController();
}
