import 'dart:convert';
import 'dart:js_interop';

import 'package:copper_app/services/kicad_parser/kicad_pcb_design.dart';

/// Parses an S-Expression formatted KiCAD PCB file.
///
/// PCB design files created using KiCAD (.kicad_pcb files) are formatted as S-Expressions. S-Expressions are a simple
/// text-based format for representing nested lists. You can find documentation about the KiCAD PCB S-Expression
/// syntax [on the KiCAD documentation site](https://dev-docs.kicad.org/en/file-formats/sexpr-intro/).
///
/// This class parses the content of a KiCAD PCB file and returns a [KiCadPCBDesign] object that represents the parsed
/// data. This [KiCadPCBDesign] object can be used to access the data in a structured format.
///
/// The following syntax rules are used in KiCAD S-Expressions:
///
/// - Syntax is based on the Specctra DSN file format.
/// - Token definitions are delimited by opening ( and closing ) parenthesis.
/// - All tokens are lowercase.
/// - Tokens cannot contain any white space characters or special characters other than the underscore '_' character.
/// - All strings are quoted using the double quote character (") and are UTF-8 encoded.
/// - Tokens can have zero or more attributes.
/// - Human readability is a design goal.
class KiCadPCBParser {
  /// Parses the contents of a KiCAD PCB file and returns a [KiCadPCBDesign] object.
  static KiCadPCBDesign parse(String sExprString) {
    // Parse the S-Expression string into a normalized, structured JSON-like object.
    final Map<String, dynamic> parsedData = jsonDecode(jsonEncode(_parseSExpr(sExprString))) as Map<String, dynamic>;

    // Create a KiCadPCBDesign object from the parsed data.
    return KiCadPCBDesign.fromKiCadSExpr(parsedData);
  }

  /// Parses an S-Expression formatted string and returns a structured JSON-like object.
  ///
  /// This function reads KiCAD PCB files written in S-Expression format, a hierarchical data format similar to Lisp.
  /// The function processes the string to extract structured data, returning a nested list representation.
  ///
  /// ## Variables Used:
  /// - `stack`: A list that keeps track of nested lists as they are being built.
  /// - `current`: The current list being constructed.
  /// - `buffer`: A temporary string buffer that accumulates characters before being added as a token.
  /// - `inString`: A boolean flag to track whether we are inside a quoted string.
  ///
  /// ## How it Works:
  /// - Iterates over each character in the input string.
  /// - When encountering `(`, a new nested list starts, pushing the current list onto the stack.
  /// - When encountering `)`, the current list is completed and appended to the parent list in the stack.
  /// - When encountering a quoted string, it toggles the `inString` flag to keep multi-word values together.
  /// - Spaces separate tokens unless inside a quoted string.
  /// - Once finished, it returns the first parsed element (the root of the PCB data).
  static Map<String, dynamic> _parseSExpr(String input) {
    // Keeps track of nested structures during parsing.
    final List<dynamic> stack = [];

    // Holds the current working list of parsed elements.
    List<dynamic> current = [];

    // Temporarily stores characters forming a token.
    String buffer = '';

    // Flag to indicate if we are inside a quoted string.
    bool inString = false;

    // Iterate over each character in the input string.
    for (int i = 0; i < input.length; i++) {
      final String char = input[i];

      // If the character is `(`, start a new nested list; push the current list onto the stack and create a new one.
      if (char == '(' && !inString) {
        stack.add(current);
        current = [];
      }
      // Otherwise, if the character is `)`, finalize the current list and attach it to its parent.
      else if (char == ')' && !inString) {
        if (buffer.isNotEmpty) {
          current.add(buffer);
          buffer = '';
        }

        // Retrieve parent list from the stack.
        final List<dynamic> last = stack.removeLast() as List<dynamic>
          // Add the completed list to its parent.
          ..add(current);

        // Set the new working list to the parent.
        current = last;
      }
      // Toggle the string flag to track whether we are inside or outside a quoted string.
      else if (char == '"') {
        inString = !inString;
      }
      // If encountering whitespace outside of a string, finalize the buffer as a token.
      else if (char.trim().isEmpty && !inString) {
        if (buffer.isNotEmpty) {
          current.add(buffer);
          buffer = '';
        }
      }
      // Otherwise, continue accumulating characters into the buffer.
      else {
        buffer += char;
      }
    }

    // Convert `JSArray<dynamic>` to a Dart `List<dynamic>` if necessary.
    // ignore: invalid_runtime_check_with_js_interop_types
    if (current is JSArray<JSAny>) {
      current = List<dynamic>.from(current);
    }

    // Convert `JSArray<dynamic>` to a Dart `List<dynamic>` if necessary.
    // ignore: invalid_runtime_check_with_js_interop_types
    if (current is JSArray<JSAny>) {
      current = List<dynamic>.from(current);
    }

    // If `current` contains only one element and that element is a list, extract it.
    if (current.length == 1 && current.first is List<dynamic>) {
      current = current.first as List<dynamic>;
    }

    // Ensure we are working with a structured object.
    if (current.isNotEmpty && current.first is String) {
      final String rootKey = current.first as String;
      final Map<String, dynamic> structuredMap = {rootKey: current.sublist(1)};

      return structuredMap;
    }

    throw const FormatException('Invalid S-Expression format for KiCAD PCB.');
  }
}
