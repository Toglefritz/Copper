import 'package:circuit_check_app/screens/parsing/parsing_route.dart';
import 'package:circuit_check_app/services/kicad_parser/kicad_pcb_design.dart';
import 'package:circuit_check_app/services/kicad_parser/kicad_pcb_parser.dart';
import 'package:flutter/material.dart';

import '../analysis/analysis_route.dart';
import 'parsing_view.dart';

/// Controller for the [ParsingRoute].
class ParsingController extends State<ParsingRoute> {
  @override
  void initState() {
    // Parse the PCB design file.
    _parsePcbDesignFile();

    super.initState();
  }

  /// Parses the PCB design file.
  ///
  /// This method is responsible for parsing the PCB design file provided by the user. The file is parsed and the
  /// results are stored in the [KiCadPCBDesign] object.
  void _parsePcbDesignFile() {
    // TODO(Toglefritz): Determine PCB file format

    final KiCadPCBDesign pcbDesign = KiCadPCBParser.parse(widget.fileContents);

    // Navigate to the report generation screen.
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigateToReportGenerator(pcbDesign));
  }

  /// Navigates to the screen for generating a report.
  void _navigateToReportGenerator(KiCadPCBDesign pcbDesign) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (context) => AnalysisRoute(
          pcbDesign: pcbDesign,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ParsingView(this);
}
