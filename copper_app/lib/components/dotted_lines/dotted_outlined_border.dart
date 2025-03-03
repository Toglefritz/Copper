import 'dart:ui';

import 'package:flutter/material.dart';

/// A custom [OutlinedBorder] that creates a dotted border around a widget.
///
/// This border can be customized to adjust the dot size, dot gap, stroke width, color, and corner radius. It
/// extends the [OutlinedBorder] class, making it easy to use in various widgets like [OutlinedButton].
class DottedOutlinedBorder extends OutlinedBorder {
  /// Creates a dotted border with the given properties.
  ///
  /// [color] defines the color of the dotted border.
  /// [dotSize] defines the size of each dot.
  /// [dotGap] defines the gap between each dot.
  /// [borderRadius] defines the radius of the border's corners.
  const DottedOutlinedBorder({
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
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final RRect outer = borderRadius.toRRect(rect);
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
  OutlinedBorder copyWith({BorderSide? side}) {
    return DottedOutlinedBorder(
      color: side?.color ?? color,
      dotSize: dotSize,
      dotGap: dotGap,
      borderRadius: borderRadius,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return DottedOutlinedBorder(
      color: color,
      dotSize: dotSize * t,
      dotGap: dotGap * t,
      borderRadius: borderRadius * t,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(dotSize);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.toRRect(rect));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.toRRect(rect));
  }
}
