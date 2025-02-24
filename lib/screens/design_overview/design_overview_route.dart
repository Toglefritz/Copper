import 'package:circuit_check_app/services/kicad_parser/kicad_pcb_design.dart';
import 'package:flutter/material.dart';

import 'design_overview_controller.dart';

/// Displays an overview of a PCB design file.
///
/// This route displays an overview of information about a PCB design file provided by the user. It also provides
/// an interface allowing the user to ask questions or request information about the PCB design file. The user can
/// also navigate to other screens to view more detailed information about the PCB design file or its individual
/// components or other parts. Ultimately, the purpose of this route is provide an interface for users to prompt
/// an AI system as a way of interacting with the PCB design file.
class DesignOverviewRoute extends StatefulWidget {
  /// Creates an instance of [DesignOverviewRoute].
  const DesignOverviewRoute({
    required this.fileName,
    required this.pcbDesign,
    super.key,
  });

  /// The name of the PCB design file provided to the app.
  final String fileName;

  /// An object representing information about the PCB design file.
  final KiCadPCBDesign pcbDesign;

  @override
  State<DesignOverviewRoute> createState() => DesignOverviewController();
}
