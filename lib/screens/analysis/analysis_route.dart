import 'package:circuit_check_app/services/kicad_parser/kicad_pcb_design.dart';
import 'package:flutter/material.dart';

import 'analysis_controller.dart';

/// Analyzes a PCB design and generates a report for the user.
///
/// This route accepts information about a PCB design file parsed by this app. This information is in a format that
/// allows for easy manipulation and handling by the app. The app uses this PCB design information to create a
/// prompt for an LLM system to analyze the PCB design and generate a report for the user.
///
/// This app uses an LLM system from Azure AI Services to analyze the PCB design and generate a report. In order to
/// get the best results from the LLM, the app must provided with the LLM with information about the PCB design in
/// its prompt in a format that the LLM can understand. The app uses the PCB design information to create this prompt.
///
/// After creating the prompt, the app sends the prompt to the LLM system. The LLM system analyzes the PCB design and
/// generates a report. The app then displays this report to the user.
class AnalysisRoute extends StatefulWidget {
  /// Creates an instance of [AnalysisRoute].
  const AnalysisRoute({
    required this.pcbDesign,
    super.key,
  });

  /// An object representing information about the PCB design file.
  // TODO(Toglefritz): Support multiple PCB design formats.
  final KiCadPCBDesign pcbDesign;

  @override
  State<AnalysisRoute> createState() => AnalysisController();
}
