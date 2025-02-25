import 'package:copper_app/components/loaders/delay_tween.dart';
import 'package:flutter/widgets.dart';

/// A widget that displays a perpetual loading indicator pulsing in a grid pattern.
class PulsingGridLoader extends StatefulWidget {
  /// Creates an instance of the [PulsingGridLoader] widget.
  ///
  /// The [color] and [itemBuilder] parameters are mutually exclusive. You must specify either a [color] or an [itemBuilder].
  /// The [size] parameter defaults to 50.0.
  /// The [duration] parameter defaults to 1500 milliseconds.
  const PulsingGridLoader({
    super.key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1500),
    this.boxShape,
    this.controller,
  })  : assert(
          !(itemBuilder is IndexedWidgetBuilder && color is Color) && !(itemBuilder == null && color == null),
          'You should specify either an itemBuilder or a color',
        );

  /// The color of the pulsing items.
  final Color? color;

  /// The size of the grid.
  final double size;

  /// A builder for creating custom items in the grid.
  final IndexedWidgetBuilder? itemBuilder;

  /// The duration of the pulsing animation.
  final Duration duration;

  /// The shape of the pulsing items.
  final BoxShape? boxShape;

  /// An optional animation controller.
  final AnimationController? controller;

  @override
  State<PulsingGridLoader> createState() => _PulsingGridLoaderState();
}

/// The state of the [PulsingGridLoader] widget.
class _PulsingGridLoaderState extends State<PulsingGridLoader> with SingleTickerProviderStateMixin {
  static const int _gridCount = 3;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))..repeat();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size.square(widget.size),
        child: Stack(
          children: List.generate(_gridCount * _gridCount, (int i) {
            // Calculate the row and column of the current item.
            final int row = i ~/ _gridCount;
            final int column = i % _gridCount;

            // Determine if the current item is the middle item.
            final bool isMid = i == (_gridCount * _gridCount - 1) ~/ 2;

            // Calculate the position and delay for the current item.
            final double position = widget.size * 0.7;
            final double delay = isMid ? 0.25 : (i.isOdd ? 0.5 : 0.75);

            return Positioned.fill(
              left: position * (-1 + column),
              top: position * (-1 + row),
              child: Align(
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: DelayTween(
                      begin: 0.0,
                      end: 1.0,
                      delay: delay,
                    ).animate(_controller),
                    curve: Curves.easeOut,
                  ),
                  child: SizedBox.fromSize(
                    size: Size.square(widget.size / 4),
                    child: _buildItem(i),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    return widget.itemBuilder != null
        ? widget.itemBuilder!(context, index)
        : DecoratedBox(
            decoration: BoxDecoration(
              color: widget.color,
              shape: widget.boxShape ?? BoxShape.circle,
            ),
          );
  }
}
