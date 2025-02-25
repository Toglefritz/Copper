import 'package:copper_app/services/kicad_parser/kicad_pcb_component.dart';
import 'package:flutter/material.dart';

import 'schematic_painter.dart';

/// A widget that displays a schematic view of PCB components and their connections.
///
/// The [SchematicView] takes a list of [KiCadPCBComponent] objects and uses a [SchematicPainter]
/// to draw the components and their connections on a canvas. The colors for components, connections,
/// and text labels can be customized.
class SchematicView extends StatelessWidget {
  /// A list of PCB components to be visualized.
  final List<KiCadPCBComponent> components;

  /// The color used for drawing components.
  final Color componentColor;

  /// The color used for drawing connections (lines) among components.
  final Color connectionColor;

  /// The color used for the text labels of components.
  final Color textColor;

  /// Creates a [SchematicView] widget.
  const SchematicView({
    required this.components,
    required this.componentColor,
    required this.connectionColor,
    required this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the number of columns and rows needed to display the components in a grid layout. This is used to
    // determine the required size of the `CustomPaint` widget.
    const double gridSpacing = 180.0;
    const int columns = 5;
    final int rows = (components.length / columns).ceil();
    final double height = rows * gridSpacing;

    return CustomPaint(
      size: Size(double.infinity, height),
      painter: SchematicPainter(
        components: components,
        componentColor: componentColor,
        connectionColor: connectionColor,
        textColor: textColor,
      ),
    );
  }
}
