import 'package:copper_app/services/kicad_parser/kicad_component_pad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../services/kicad_parser/kicad_pcb_component.dart';
import '../design_overview_controller.dart';

/// A table presenting information about the components in the PCB design.
class ComponentsTable extends StatelessWidget {
  /// Creates an instance of [ComponentsTable].
  const ComponentsTable({
    required this.state,
    super.key,
  });

  /// A controller for this view.
  final DesignOverviewController state;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(0.2),
        1: FlexColumnWidth(0.8),
        2: FlexColumnWidth(0.1),
      },
      border: TableBorder(
        horizontalInside: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 0.5,
        ),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            Text(
              AppLocalizations.of(context)!.componentsTitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              AppLocalizations.of(context)!.descriptionTitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              AppLocalizations.of(context)!.padsTitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        for (final KiCadPCBComponent component in state.getComponentsWithPads())
          TableRow(
            children: [
              Text(
                component.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                component.description != null ? state.getSanitizedDescription(component.description!) : '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final KiCadComponentPad pad in component.pads)
                    Text(
                      pad.net?.name ?? pad.net?.code.toString() ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
