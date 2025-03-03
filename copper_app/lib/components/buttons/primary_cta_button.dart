import 'package:flutter/material.dart';

/// A primary call-to-action button.
class PrimaryCtaButton extends StatelessWidget {
  /// Creates an instance of [PrimaryCtaButton].
  const PrimaryCtaButton({
    required this.onPressed,
    required this.child,
    super.key,
  });

  /// The callback that is called when the button is tapped.
  final VoidCallback onPressed;

  /// The widget that is displayed inside the button.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
