import 'package:copper_app/components/dotted_lines/dotted_box_border.dart';
import 'package:copper_app/components/dotted_lines/dotted_divider.dart';
import 'package:copper_app/extensions/date_time_extensions.dart';
import 'package:copper_app/services/design_analysis/models/analysis_response.dart';
import 'package:copper_app/theme/insets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../design_overview_controller.dart';

/// A list of past analysis prompts and their results.
///
/// This widget displays a list of past analysis prompts and their results. The list is displayed in a container with a
/// border and rounded corners. Each item in the list is separated by a dotted line.
class AnalysisHistoryContainer extends StatelessWidget {
  /// Creates an instance of [AnalysisHistoryContainer].
  const AnalysisHistoryContainer({
    required this.state,
    super.key,
  });

  /// A controller for this view.
  final DesignOverviewController state;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.6,
      ),
      decoration: BoxDecoration(
        border: DottedBoxBorder(color: Theme.of(context).colorScheme.onPrimary),
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(Insets.small),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.analysisResults,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.analysisHistory.length,
            itemBuilder: (BuildContext context, int index) {
              final AnalysisResponse analysis = state.analysisHistory[index];

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Insets.small,
                ),
                child: ListTile(
                  leading: Text(
                    analysis.timestamp.formattedDateTime,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                  title: Text(
                    analysis.prompt.length > 256 ? '${analysis.prompt.substring(0, 256)}...' : analysis.prompt,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  onTap: () => state.onHistoryItemTap(analysis),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => DottedDivider(
              color: Theme.of(context).colorScheme.onPrimary,
              dotSize: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
