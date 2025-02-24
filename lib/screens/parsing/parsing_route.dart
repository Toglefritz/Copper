import 'package:flutter/material.dart';

import 'parsing_controller.dart';

/// This route is displayed while the app is parsing a PCB design file provided by the user.
class ParsingRoute extends StatefulWidget {
  /// Creates an instance of [ParsingRoute].
  const ParsingRoute({
    required this.fileName,
    required this.fileContents,
    super.key,
  });

  /// The name of the PCB design file provided to the app.
  final String fileName;

  /// The contents of a PCB design file.
  final String fileContents;

  @override
  State<ParsingRoute> createState() => ParsingController();
}
