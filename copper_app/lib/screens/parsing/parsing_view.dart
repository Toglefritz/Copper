import 'package:copper_app/components/loaders/pulsing_grid_loader.dart';
import 'package:copper_app/theme/insets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'parsing_controller.dart';
import 'parsing_route.dart';

/// View for the [ParsingRoute].
///
/// This view simply displays a loading indicator while the app parses the PCB design file.
class ParsingView extends StatelessWidget {
  /// Creates an instance of [ParsingView].
  const ParsingView(this.state, {super.key});

  /// A controller for this view.
  final ParsingController state;

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
                AppLocalizations.of(context)!.parsingMessage,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
