import 'package:copper_app/components/dotted_lines/dotted_box_border.dart';
import 'package:copper_app/components/loaders/pulsing_grid_loader.dart';
import 'package:copper_app/theme/insets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../design_overview_controller.dart';

/// A text field used to enter or modify the project analysis prompt and submit it to the server.
class AnalysisPromptField extends StatelessWidget {
  /// Creates an instance of [AnalysisPromptField].
  const AnalysisPromptField({
    required this.state,
    super.key,
  });

  /// A controller for this view.Ï
  final DesignOverviewController state;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: state.isAnalyzing ? 0.5 : 1.0,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
            ),
            decoration: BoxDecoration(
              border: DottedBoxBorder(color: Theme.of(context).colorScheme.onPrimary),
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.all(Insets.small),
            child: TextField(
              controller: state.projectAnalysisPromptController,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              enabled: !state.isAnalyzing,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.projectAnalysisPromptTitle,
                contentPadding: const EdgeInsets.all(Insets.small),
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Insets.small),
                  child: IconButton(
                    icon: const Icon(Icons.done_outline),
                    onPressed: state.onAnalysisPromptSubmit,
                  ),
                ),
              ),
              minLines: 3,
              maxLines: null,
              onSubmitted: (_) => state.onAnalysisPromptSubmit(),
            ),
          ),
        ),

        // Display a loading indicator while the PCB design is being analyzed.
        if (state.isAnalyzing)
          PulsingGridLoader(
            color: Theme.of(context).colorScheme.onSurface,
            size: 42.0,
          ),
      ],
    );
  }
}
