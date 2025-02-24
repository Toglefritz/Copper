import 'package:circuit_check_app/components/dotted_lines/dotted_line_painter.dart';
import 'package:flutter/material.dart';

/// A widget that draws a horizontal dotted divider line.
///
/// The [DottedDivider] widget creates a horizontal line with a dotted pattern,
/// which can be customized by specifying the dot size, dot gap, and color.
class DottedDivider extends StatelessWidget {
  /// The height of the divider.
  final double height;

  /// The diameter of each dot.
  final double dotSize;

  /// The gap between each dot.
  final double dotGap;

  /// The color of the dotted divider.
  final Color color;

  /// Creates a dotted divider with the given properties.
  ///
  /// The [height] specifies the height of the divider.
  /// The [dotSize] specifies the diameter of each dot.
  /// The [dotGap] specifies the gap between each dot.
  /// The [color] specifies the color of the dotted divider.
  const DottedDivider({
    super.key,
    this.height = 1.0,
    this.dotSize = 3.0,
    this.dotGap = 3.0,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, height),
      painter: DottedLinePainter(
        dotSize: dotSize,
        dotGap: dotGap,
        color: color,
      ),
    );
  }
}
