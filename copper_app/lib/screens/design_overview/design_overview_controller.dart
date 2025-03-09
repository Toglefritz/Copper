import 'package:copper_app/services/design_analysis/design_analysis_service.dart';
import 'package:copper_app/services/kicad_parser/kicad_component_pad.dart';
import 'package:flutter/material.dart';
import '../../services/kicad_parser/kicad_pcb_component.dart';
import 'design_overview_route.dart';
import 'design_overview_view.dart';

/// Controller for the [DesignOverviewRoute].
class DesignOverviewController extends State<DesignOverviewRoute> {
  // TODO(Toglefritz): Check if information about the project is available from the cloud

  /// A controller for the text form field used to edit the project description.
  final TextEditingController projectDescriptionController = TextEditingController();

  /// A controller for the text form field used to edit the project analysis prompt.
  final TextEditingController projectAnalysisPromptController = TextEditingController();

  /// A setter for the project description.
  set projectDescription(String? description) {
    setState(() {
      widget.pcbDesign.projectDescription = description;
    });
  }

  /// A getter for the project description.
  String? get projectDescription => widget.pcbDesign.projectDescription;

  @override
  void initState() {
    // Set the initial value for the project description text field.
    projectDescriptionController.text = projectDescription ?? '';

    super.initState();
  }

  /// Called when the user saves a new project description.
  Future<void> onProjectDescriptionSave() async {
    // Save the new project description from the text field.
    projectDescription = projectDescriptionController.text;

    // Save the project description to the cloud.
    // TODO(Toglefritz): Implement saving the project description to the cloud
  }

  /// Returns a list of PCB components with pads.
  ///
  /// Components (a.k.a. footprints) in a PCB design file can include electrical components placed onto the PCB,
  /// as well as other components like mounting holes, test points, logos, and other non-electrical components.
  /// Typically, in an overview about the PCB design, only the electrical components are listed.
  ///
  /// This getter returns a list of components that have named pads, which are the electrical connections on the
  /// component. The list is sorted by the number of pads, with the components having more pads listed first.
  List<KiCadPCBComponent> getComponentsWithPads() {
    // Get the components from the PCB design that have pads.
    final List<KiCadPCBComponent> componentsWithPads =
        widget.pcbDesign.components.where((KiCadPCBComponent component) => component.pads.isNotEmpty).toList()

          // Sort the components by the number of pads, with the components having more pads listed first.
          ..sort((KiCadPCBComponent a, KiCadPCBComponent b) => b.pads.length.compareTo(a.pads.length))

          // Remove components for which none of the pads have a name.
          ..removeWhere(
            (KiCadPCBComponent component) =>
                component.pads.every((KiCadComponentPad pad) => pad.net?.name?.isEmpty ?? true),
          );

    return componentsWithPads;
  }

  /// Sanitizes and returns a description of a component.
  ///
  /// Descriptions for components in PCB designs generally uses a free text format. Therefore, they can contain
  /// special characters, line breaks, and other formatting that may not be suitable for display in a user interface.
  /// This method sanitizes the description by formatting the string to ensure it is displayed in a visually appealing
  /// way.
  String getSanitizedDescription(String rawDescription) {
    // Convert the description into character codes. This allows for easier manipulation of escape characters in
    // the string, especially those used for "\n" (line breaks), where the newline character is represented by two
    // characters.
    final List<int> charCodes = rawDescription.codeUnits;

    // Convert the character codes back into a string while replacing occurrences of the escape sequence `\n`
    // (represented by character codes 92 and 110) with an actual newline character.
    String sanitizedDescription = '';
    for (int i = 0; i < charCodes.length; i++) {
      // Check for the backslash character (`\`)
      if (charCodes[i] == 92 && i + 1 < charCodes.length && charCodes[i + 1] == 110) {
        // If the next character is 'n', replace both with a newline character.
        sanitizedDescription += '\n';
        i++; // Skip the next character ('n')
      } else {
        // Otherwise, add the character as is.
        sanitizedDescription += String.fromCharCode(charCodes[i]);
      }
    }

    // Remove any doubled newline characters to prevent excessive spacing.
    // ignore: join_return_with_assignment
    sanitizedDescription = sanitizedDescription.replaceAll('\n\n', '\n');

    return sanitizedDescription;
  }

  /// Handles submission of an analysis prompt.
  ///
  /// This method is called when the user submits an analysis prompt. It uses the [DesignAnalysisService] to send the
  /// prompt, along with information about the PCB design, to an LLM in Azure Open AI Services. The LLM responds
  /// with an analysis of the PCB design based on the prompt and the information provided. This response is displayed
  /// to the user in the app.
  Future<void> onAnalysisPromptSubmit() async {
    // Get the prompt from the text field.
    final String prompt = projectAnalysisPromptController.text;

    // Get an instance of the DesignAnalysisService to send the prompt to the LLM.
    final DesignAnalysisService designAnalysisService = DesignAnalysisService();

    // Send the prompt to the LLM and get the response.
    final String analysisResponse = await designAnalysisService.analyzePCBDesign(
      pcbDesign: widget.pcbDesign,
      userQuery: prompt,
    );

    debugPrint('Analysis response: $analysisResponse');

    // TODO(Toglefritz): Display the analysis response to the user.
  }

  @override
  Widget build(BuildContext context) => DesignOverviewView(this);
}
