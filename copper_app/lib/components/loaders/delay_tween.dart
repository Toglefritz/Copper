import 'dart:math' as math show pi, sin;
import 'package:flutter/animation.dart';

/// A custom tween that applies a delay to the interpolation of an animation.
///
/// This class extends [Tween] and modifies the interpolation function to introduce a sinusoidal delay effect. The
/// delay shifts the animation phase, causing a smooth easing effect rather than a linear interpolation.
///
/// **Note:** The `delay` value should be in the range `[0, 1]`, where `0` means no delay, and `1` means a full phase
/// shift in the sine wave.
class DelayTween extends Tween<double> {
  /// Creates a [DelayTween] with an optional beginning and end value, and a required delay parameter.
  ///
  /// - The [begin] and [end] define the range of values the tween interpolates between.
  /// - The [delay] parameter shifts the phase of the sine function to delay the animation.
  ///
  /// Throws an assertion error if [delay] is not provided.
  DelayTween({
    required this.delay,
    super.begin,
    super.end,
  });

  /// The amount of delay applied to the animation, expressed as a fraction of the cycle.
  ///
  /// A `delay` value of `0` results in no phase shift, while `0.5` results in the maximum delay effect.
  final double delay;

  /// Interpolates the value at a given time `t`, applying a sinusoidal delay.
  ///
  /// The function modifies `t` by shifting it based on `delay`, then applies a sine function to create a smooth easing
  /// effect. The sine wave oscillates between `-1` and `1`, so it is normalized to fit within `[0, 1]`.
  ///
  /// - `t` is the normalized animation progress (`0.0` to `1.0`).
  /// - The returned value is mapped to the range between [begin] and [end].
  ///
  /// ### Formula:
  /// ```dart
  /// lerp(t) = Tween.lerp((sin((t - delay) * 2 * pi) + 1) / 2)
  /// ```
  ///
  /// This results in a smooth oscillation effect with a phase shift based on `delay`.
  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  /// Evaluates the tween using the provided animation and applies the interpolation.
  ///
  /// This function retrieves the current progress of the animation and passes it to [lerp] to compute the interpolated
  /// value.
  ///
  /// - The `animation.value` is a normalized value between `0.0` and `1.0`.
  /// - The returned value is the interpolated result after applying the delay effect.
  ///
  /// This method ensures that the animation value smoothly oscillates while respecting the phase shift introduced by
  /// `delay`.
  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
