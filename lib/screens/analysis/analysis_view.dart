import 'package:copper_app/components/loaders/pulsing_grid_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../theme/insets.dart';
import 'analysis_controller.dart';
import 'analysis_route.dart';

/// View for the [AnalysisRoute].
///
/// This view simply displays a loading indicator while the app and its associated backend services analyze the PCB
/// design.
class AnalysisView extends StatelessWidget {
  /// Creates an instance of [AnalysisView].
  const AnalysisView(this.state, {super.key});

  /// A controller for this view.
  final AnalysisController state;

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
            Padding(
              padding: const EdgeInsets.all(Insets.medium),
              child: Text(
                AppLocalizations.of(context)!.analysisMessage,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
