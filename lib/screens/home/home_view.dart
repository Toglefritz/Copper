import 'package:circuit_check_app/screens/home/components/pcb_file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            AppLocalizations.of(context)!.homeTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
      body: PCBFilePicker(
        onFileSelected: state.handleFileSelected,
        onDropzoneViewCreated: (DropzoneViewController controller) => state.dropzoneViewController = controller,
        onDropFile: state.handleDropFile,
      ),
    );
  }
}
