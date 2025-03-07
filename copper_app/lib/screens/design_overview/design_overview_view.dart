import 'package:copper_app/theme/insets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // PCB project description field
              ProjectDescriptionField(state: state),

              // Information about the PCB design
              PcbInformationContainer(state: state),
            ],
          ),
        ),
      ),
    );
  }
}
