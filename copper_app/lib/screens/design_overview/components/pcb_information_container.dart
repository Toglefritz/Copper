import 'package:copper_app/components/dotted_lines/dotted_divider.dart';
import 'package:copper_app/screens/design_overview/components/schematic/schematic_view.dart';
import 'package:copper_app/theme/insets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../components/dotted_lines/dotted_box_border.dart';
import '../design_overview_controller.dart';
import 'components_table.dart';

/// A widget displaying an overview of the PCB design.
class PcbInformationContainer extends StatelessWidget {
  /// Creates an instance of [PcbInformationContainer].
  const PcbInformationContainer({
    required this.state, super.key,
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
          // File name
          ListTile(
            leading: Text(
              AppLocalizations.of(context)!.fileNameTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            trailing: Text(
              state.widget.pcbDesign.fileName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),

          // Section divider
          DottedDivider(
            color: Theme.of(context).colorScheme.onPrimary,
            dotSize: 0.5,
          ),

          // List of components
          ListTile(
            leading: Text(
              AppLocalizations.of(context)!.componentsTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Insets.small),
            child: ComponentsTable(state: state),
          ),

          // Section divider
          Padding(
            padding: const EdgeInsets.only(top: Insets.medium),
            child: DottedDivider(
              color: Theme.of(context).colorScheme.onPrimary,
              dotSize: 0.5,
            ),
          ),

          // Schematic view
          ListTile(
            leading: Text(
              AppLocalizations.of(context)!.connectionsTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: Insets.large),
            child: SchematicView(
              components: state.getComponentsWithPads(),
              componentColor: Theme.of(context).colorScheme.onPrimary,
              connectionColor: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.3),
              textColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
