import 'package:copper_app/services/kicad_parser/kicad_pcb_component.dart';
import 'package:flutter/material.dart';

/// A custom painter widget that visualizes the electrical connections among components in a PCB design.
///
/// The [SchematicPainter] takes a list of [KiCadPCBComponent] objects and draws them on a canvas.
/// Each component is represented by a circle, and connections between components are drawn as lines among components
/// that are connected to the same electrical networks on the PCB.
///
/// The colors for components and connections can be customized.
class SchematicPainter extends CustomPainter {
  /// A list of PCB components to be visualized.
  final List<KiCadPCBComponent> components;

  /// The color used for drawing components.
  final Color componentColor;

  /// The color used for drawing connections (lines) among components.
  final Color connectionColor;

  /// The color used for the text labels of components.
  final Color textColor;

  /// Creates a [SchematicPainter] widget.
  SchematicPainter({
    required this.components,
    required this.componentColor,
    required this.connectionColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint componentPaint = Paint()
      ..color = componentColor
      ..style = PaintingStyle.fill;

    final Paint connectionPaint = Paint()
      ..color = connectionColor
      ..strokeWidth = 2.0;

    const double gridSpacing = 180.0;
    final Map<String, Offset> netPositions = {};

    for (int i = 0; i < components.length; i++) {
      final component = components[i];
      final double x = (i % 5) * gridSpacing + gridSpacing / 2;
      final double y = (i ~/ 5) * gridSpacing + (i.isEven ? gridSpacing / 2 : gridSpacing);
      final Offset componentPosition = Offset(x, y);

      // Draw component
      canvas.drawCircle(componentPosition, 10.0, componentPaint);

      // Draw connections
      for (final pad in component.pads) {
        final netName = pad.net?.name ?? pad.net?.code.toString() ?? '';
        if (netPositions.containsKey(netName)) {
          final Offset netPosition = netPositions[netName]!;
          canvas.drawLine(componentPosition, netPosition, connectionPaint);
        } else {
          netPositions[netName] = componentPosition;
        }
      }

      // Draw component name above the component
      TextPainter(
        text: TextSpan(
          text: component.name,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout()
        ..paint(canvas, componentPosition + const Offset(-12.0, -28.0));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
