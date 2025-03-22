import 'package:copper_app/extensions/date_time_extensions.dart';
import 'package:copper_app/services/design_analysis/models/analysis_response.dart';
import 'package:copper_app/theme/insets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'components/analysis_history_container.dart';
import 'components/analysis_prompt_field.dart';
import 'components/pcb_information_container.dart';
import 'components/project_description_field.dart';
import 'design_overview_controller.dart';
import 'design_overview_route.dart';

/// View for the [DesignOverviewRoute].
class DesignOverviewView extends StatelessWidget {
  /// Creates an instance of [DesignOverviewView].
  const DesignOverviewView(this.state, {super.key});

  /// A controller for this view.
  final DesignOverviewController state;

  /// Displays a bottom modal windows with the results of the analysis.
  ///
  /// After the user submits the analysis prompt, the app sends the prompt information to the LLM, and a response is
  /// received, this modal windows is used to display the analysis results. Because the analysis information is
  /// long, this modal window occupies 95% of the screen height.
  // TODO(Toglefritz): Use a custom class to represent the analysis response.
  static Future<void> showAnalysisResultsModal(BuildContext context, AnalysisResponse analysisResponse) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.95,
        padding: const EdgeInsets.all(Insets.small),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.analysisResults,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                analysisResponse.timestamp.formattedDateTime,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Insets.small,
                ),
                child: MarkdownBody(
                  data: analysisResponse.responseData,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Displays an alert dialog confirming that the user wishes to delete the current PCB design.
  static Future<bool?> showDeleteDesignAlertDialog(BuildContext context) async {
    final bool? didConfirmDeletion = await showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteDesign),
        content: Text(AppLocalizations.of(context)!.deleteDesignPrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: TextStyle(
                color: Colors.red[900],
              ),
            ),
          ),
        ],
      ),
    );

    return didConfirmDeletion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: state.onHome,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(Insets.medium),
                  child: Image.asset(
                    'assets/copper_icon_48.png',
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.homeTitle,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Insets.medium),
            child: MenuAnchor(
              menuChildren: [
                MenuItemButton(
                  onPressed: state.onDeleteDesign,
                  child: Text(AppLocalizations.of(context)!.deleteDesign),
                ),
              ],
              alignmentOffset: const Offset(
                -Insets.medium,
                0.0,
              ),
              builder: (_, MenuController controller, Widget? child) {
                return IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // PCB project description field
              ProjectDescriptionField(state: state),

              // Information about the PCB design
              PcbInformationContainer(state: state),

              // Project analysis prompt field
              AnalysisPromptField(state: state),

              // Display the chat history.
              if (state.analysisHistory.isNotEmpty) AnalysisHistoryContainer(state: state),
            ],
          ),
        ),
      ),
    );
  }
}
