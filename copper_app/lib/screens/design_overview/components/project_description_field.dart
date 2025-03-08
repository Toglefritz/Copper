import 'package:copper_app/theme/insets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../components/dotted_lines/dotted_box_border.dart';
import '../design_overview_controller.dart';

/// A text field used to enter or modify the project description.
class ProjectDescriptionField extends StatelessWidget {
  /// Creates an instance of [ProjectDescriptionField].
  const ProjectDescriptionField({
    required this.state,
    super.key,
  });

  /// A controller for this view.
  final DesignOverviewController state;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
          ),
          decoration: BoxDecoration(
            border: DottedBoxBorder(color: Theme.of(context).colorScheme.onPrimary),
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: const EdgeInsets.all(Insets.small),
          child: TextField(
            controller: state.projectDescriptionController,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.projectDescriptionTitle,
              contentPadding: const EdgeInsets.all(Insets.small),
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Insets.small),
                child: IconButton(
                  icon: const Icon(Icons.save_outlined),
                  onPressed: state.onProjectDescriptionSave,
                ),
              ),
            ),
            minLines: 3,
            maxLines: null,
            onChanged: (value) => state.projectDescription = value,
          ),
        ),

        // Display an icon if there is no project description
        if (state.projectDescription == null || state.projectDescription!.isEmpty)
          IgnorePointer(
            child: Text(
              AppLocalizations.of(context)!.enterDescription,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),
      ],
    );
  }
}
