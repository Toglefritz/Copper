import 'package:circuit_check_app/components/dotted_lines/dotted_box_border.dart';
import 'package:circuit_check_app/theme/insets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A widget that allows the user to select a PCB design file by either browsing their files or dragging and dropping
/// the file.
class PCBFilePicker extends StatefulWidget {
  /// Creates an instance of [PCBFilePicker].
  const PCBFilePicker({
    required this.onFileSelected,
    required this.onDropzoneViewCreated,
    required this.onDropFile,
    super.key,
  });

  /// Callback function to handle the user choosing the option to select a file with the platform's native file picker.
  final void Function(PlatformFile filePath) onFileSelected;

  /// Callback for when the [DropzoneView] is initially loaded. This callback will initialize the controller for the
  /// [DropzoneView] widget.
  final void Function(DropzoneViewController controller) onDropzoneViewCreated;

  /// Callback function to handle files being dropped onto the widget.
  final void Function(DropzoneFileInterface file) onDropFile;

  @override
  PCBFilePickerState createState() => PCBFilePickerState();
}

/// The state of the [PCBFilePicker] widget.
class PCBFilePickerState extends State<PCBFilePicker> {
  String? _selectedFilePath;

  /// Opens the file picker and allows the user to select a KiCad PCB file using the platform's native file picker.
  Future<void> _pickFile() async {
    // Open the file picker and allow the user to select a KiCad PCB file
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['kicad_pcb'],
    );

    // If a file was selected, update the state and call the callback function
    if (result != null && result.files.single.path != null) {
      // Get a XFile object from the result
      final PlatformFile file = result.files.single;

      widget.onFileSelected(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // If the field is tapped, open the file picker.
      onTap: _pickFile,
      child: Stack(
        alignment: Alignment.center,
        children: [
          DropzoneView(
            onCreated: widget.onDropzoneViewCreated,
            operation: DragOperation.copy,
            onDropFile: widget.onDropFile,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: Insets.xxLarge),
                height: 175,
                decoration: BoxDecoration(
                  border: DottedBoxBorder(color: Theme.of(context).colorScheme.onPrimary),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.file_upload, size: 50, color: Theme.of(context).colorScheme.onPrimary),
                      Padding(
                        padding: const EdgeInsets.only(top: Insets.medium),
                        child: Text(
                          _selectedFilePath ?? AppLocalizations.of(context)!.dragAndDropFile,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
