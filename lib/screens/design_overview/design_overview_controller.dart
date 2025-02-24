import 'package:circuit_check_app/services/kicad_parser/kicad_component_pad.dart';
import 'package:flutter/material.dart';
import '../../services/kicad_parser/kicad_pcb_component.dart';
import 'design_overview_route.dart';
import 'design_overview_view.dart';

/// Controller for the [DesignOverviewRoute].
class DesignOverviewController extends State<DesignOverviewRoute> {
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

  @override
  Widget build(BuildContext context) => DesignOverviewView(this);
}
