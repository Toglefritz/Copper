import 'package:copper_app/components/loaders/pulsing_grid_loader.dart';
import 'package:flutter/material.dart';

import 'setup_controller.dart';
import 'setup_route.dart';

/// View for the [SetupRoute].
class SetupView extends StatelessWidget {
  /// Creates an instance of [SetupView].
  const SetupView(this.state, {super.key});

  /// A controller for this view.
  final SetupController state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PulsingGridLoader(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
