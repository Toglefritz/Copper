import 'package:flutter/rendering.dart';

/// A custom painter that draws a horizontal dotted line.
class DottedLinePainter extends CustomPainter {
  /// The diameter of each dot.
  final double dotSize;

  /// The gap between each dot.
  final double dotGap;

  /// The color of the dotted line.
  final Color color;

  /// Creates a dotted line painter with the given properties.
  ///
  /// The [dotSize] specifies the diameter of each dot.
  /// The [dotGap] specifies the gap between each dot.
  /// The [color] specifies the color of the dotted line.
  DottedLinePainter({
    required this.dotSize,
    required this.dotGap,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double startX = 0;

    while (startX < size.width) {
      canvas.drawCircle(Offset(startX + dotSize / 2, size.height / 2), dotSize / 2, paint);
      startX += dotSize + dotGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
