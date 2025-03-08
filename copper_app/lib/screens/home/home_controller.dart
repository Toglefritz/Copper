import 'dart:typed_data';

import 'package:copper_app/screens/home/home_route.dart';
import 'package:copper_app/screens/home/home_view.dart';
import 'package:copper_app/screens/parsing/parsing_route.dart';
import 'package:copper_app/services/authentication/authentication_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

/// Controller for the [HomeRoute].
class HomeController extends State<HomeRoute> {
  /// A controller for the [DropzoneView] widget used to allow the user to drag and drop a PCB design file into the
  /// app.
  late DropzoneViewController _dropzoneViewController;

  /// Initializes the controller when the widget is first created. Sets the [DropzoneViewController] for the
  /// [DropzoneView] widget.
  set dropzoneViewController(DropzoneViewController controller) {
    _dropzoneViewController = controller;
  }

  /// Handles the selection of a PCB design file.
  ///
  /// The user can provide a PCB design file by selecting a file from the device's file system or by dragging and
  /// dropping a file onto the app. This function handles the former method of providing a file.
  Future<void> handleFileSelected(PlatformFile file) async {
    // Get the name of the file.
    final String fileName = file.name;

    // Read the contents of the file
    final String fileContents = await _readFileAsString(file);

    // Navigate to the file parsing screen.
    _navigateToParsingScreen(
      fileName: fileName,
      fileContents: fileContents,
    );
  }

  /// Reads the contents of a file as a string on web platforms.
  Future<String> _readFileAsString(PlatformFile file) async {
    final Uint8List fileData = file.bytes!;

    final String fileContents = String.fromCharCodes(fileData);

    return fileContents;
  }

  /// Handles a file being dropped onto the app.
  ///
  /// The user can provide a PCB design file by selecting a file from the device's file system or by dragging and
  /// dropping a file onto the app. This function handles the latter method of providing a file.
  Future<void> handleDropFile(DropzoneFileInterface file) async {
    // Get the name of the file.
    final String fileName = await _dropzoneViewController.getFilename(file);

    // Check that the file is a KiCad PCB file.
    if (!fileName.endsWith('.kicad_pcb')) {
      if (!mounted) return;

      // Show a `SnackBar` to the user if the file is not in a supported format.
      HomeView.showUnsupportedFileFormatSnackBar(context);

      // Do nothing.
      return;
    }

    // Get the file data.
    final Uint8List fileData = await _dropzoneViewController.getFileData(file);

    // Convert the file data to a string.
    final String fileContents = String.fromCharCodes(fileData);

    // Navigate to the file parsing screen.
    _navigateToParsingScreen(
      fileName: fileName,
      fileContents: fileContents,
    );
  }

  /// Navigates to the screen for parsing the content of the provided PCB design file.
  void _navigateToParsingScreen({required String fileName, required String fileContents}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ParsingRoute(
          fileName: fileName,
          fileContents: fileContents,
        ),
      ),
    );
  }

  /// Handles the user logging out of the app.
  void onLogout() => AuthenticationService().logout();

  @override
  Widget build(BuildContext context) => HomeView(this);
}
