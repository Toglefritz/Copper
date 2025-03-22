import 'package:copper_app/screens/parsing/parsing_route.dart';
import 'package:copper_app/services/kicad_parser/kicad_pcb_design.dart';
import 'package:copper_app/services/kicad_parser/kicad_pcb_parser.dart';
import 'package:flutter/material.dart';
import '../design_overview/design_overview_route.dart';
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
  /// results are stored in the [KiCadPCBDesign] object. Once parsing is complete, the app navigates to a screen
  /// that displays information about the PCB design file.
  void _parsePcbDesignFile() {
    // TODO(Toglefritz): Determine PCB file format

    final KiCadPCBDesign pcbDesign = KiCadPCBParser.parse(
      sExprString: widget.fileContents,
      fileName: widget.fileName,
    );

    // Navigate to the PCB design overview screen.
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigateToDesignOverview(pcbDesign));
  }

  /// Navigates to the screen presenting an overview of the PCB design.
  void _navigateToDesignOverview(KiCadPCBDesign pcbDesign) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (context) => DesignOverviewRoute(
          pcbDesign: pcbDesign,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ParsingView(this);
}
