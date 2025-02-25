import 'dart:ui';

import 'package:flutter/material.dart';

/// A custom [BoxBorder] that creates a dotted border around a widget.
///
/// This border can be customized to adjust the dot size, dot gap, stroke width, color, and corner radius. It
/// extends the [BoxBorder] class, making it easy to use in various widgets like [Container], [DecoratedBox], or
/// [OutlinedButton].
class DottedBoxBorder extends BoxBorder {
  /// Creates a dotted border with the given properties.
  ///
  /// [color] defines the color of the dotted border.
  /// [dotSize] defines the size of each dot.
  /// [dotGap] defines the gap between each dot.
  /// [borderRadius] defines the radius of the border's corners.
  const DottedBoxBorder({
    this.color = Colors.black,
    this.dotSize = 3.0,
    this.dotGap = 3.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
  });

  /// The color of the dotted border.
  final Color color;

  /// The size of each dot.
  final double dotSize;

  /// The gap between each dot.
  final double dotGap;

  /// The radius of the border's corners.
  final BorderRadius borderRadius;

  @override
  void paint(Canvas canvas, Rect rect, {BorderRadius? borderRadius, BoxShape? shape, TextDirection? textDirection}) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final BorderRadius radius = borderRadius ?? BorderRadius.circular(12.0);

    final RRect outer = radius.toRRect(rect);
    final Path path = Path()..addRRect(outer);
    final Path dottedPath = _createDottedPath(path);

    canvas.drawPath(dottedPath, paint);
  }

  /// Creates a dotted path from a solid path.
  Path _createDottedPath(Path source) {
    final Path dottedPath = Path();
    for (final PathMetric pathMetric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final Tangent? tangent = pathMetric.getTangentForOffset(distance);
        if (tangent != null) {
          dottedPath.addOval(Rect.fromCircle(center: tangent.position, radius: dotSize / 2));
        }
        distance += dotSize + dotGap;
      }
    }

    return dottedPath;
  }

  @override
  BoxBorder add(ShapeBorder other, {bool reversed = false}) {
    throw UnimplementedError('DottedBoxBorder cannot be combined with other borders.');
  }

  @override
  BoxBorder scale(double t) {
    return DottedBoxBorder(
      color: color,
      dotSize: dotSize * t,
      dotGap: dotGap * t,
      borderRadius: borderRadius * t,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    // Implement lerpFrom if necessary for animation
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    // Implement lerpTo if necessary for animation
    return super.lerpTo(b, t);
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(dotSize);

  @override
  BorderSide get bottom => BorderSide(color: color, width: dotSize);

  @override
  bool get isUniform => true;

  @override
  BorderSide get top => BorderSide(color: color, width: dotSize);
}
