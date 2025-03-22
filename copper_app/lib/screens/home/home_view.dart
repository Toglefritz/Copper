import 'package:copper_app/screens/home/components/pcb_file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../services/kicad_parser/kicad_pcb_design.dart';
import '../../theme/insets.dart';
import 'home_controller.dart';
import 'home_route.dart';

/// View for the [HomeRoute].
class HomeView extends StatelessWidget {
  /// Creates an instance of [HomeView].
  const HomeView(this.state, {super.key});

  /// A controller for this view.
  final HomeController state;

  /// Displays a `SnackBar` to the user if they provide a file that is not in a supported format.
  static void showUnsupportedFileFormatSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.unsupportedFileFormatError),
      ),
    );
  }

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Insets.medium),
            child: MenuAnchor(
              menuChildren: [
                MenuItemButton(
                  onPressed: state.onLogout,
                  child: Text(AppLocalizations.of(context)!.logout),
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
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // PCB file picker
          PCBFilePicker(
            onFileSelected: state.handleFileSelected,
            onDropzoneViewCreated: (DropzoneViewController controller) => state.dropzoneViewController = controller,
            onDropFile: state.handleDropFile,
          ),

          // Past PCB design projects
          if (state.widget.designs.isNotEmpty)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.projectsTitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                ),
                Wrap(
                  children: List.generate(
                    state.widget.designs.length,
                    (int index) {
                      // Get the current PCB design.
                      final KiCadPCBDesign design = state.widget.designs[index];

                      return Padding(
                        padding: const EdgeInsets.all(Insets.small),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.grab,
                          child: GestureDetector(
                            onTap: () => state.onProjectSelected(design),
                            child: Chip(
                              label: Text(design.fileName),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
