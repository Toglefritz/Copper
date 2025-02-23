import 'package:circuit_check_app/services/kicad_parser/kicad_pcb_net.dart';
import 'package:collection/collection.dart';

/// Represents a single pad of a component in a KiCAD PCB design.
///
/// In KiCAD, a **pad** is a connection point on a component that allows electrical signals to be routed between
/// components on a printed circuit board. Pads are typically used for through-hole components or surface-mount
/// components that require soldering to the board. This class provides a structured way to store and interact with
/// pad data extracted from a KiCAD PCB file.
///
/// Among other information, pads store the pad number, the pad type (e.g., `smd`, `thru_hole`), and the net connection
/// associated with the pad. This information is essential for routing connections between components and ensuring
/// proper electrical connectivity in the PCB design.
// ignore_for_file: avoid_dynamic_calls
class KiCadComponentPad {
  /// The unique numerical identifier for the pad.
  ///
  /// KiCAD assigns each pad a numerical code, which serves as an internal reference. This code is used to
  /// differentiate between different pads and helps in organizing electrical connections. Note that this identifier
  /// is unique within a particular component. Different components may have pads with the same identifier.
  final int? code;

  /// The type of the pad.
  ///
  /// The pad type indicates the physical characteristics of the pad and how it is connected to the component. Common
  /// pad types include:
  ///
  /// - `smd`: Surface-mount device pad.
  /// - `thru_hole`: Through-hole pad.
  /// - `np_thru_hole`: Non-plated through-hole pad.
  /// - `connect`: Connection pad (e.g., for test points).
  final String? type;

  /// The net connection associated with the pad.
  ///
  /// The net connection represents the electrical signal or connection to which the pad is linked. This connection
  /// helps in routing signals between components on the PCB. The net is identified by its name or code, which is
  /// used to establish electrical connectivity in the design. If multiple pads have connections to the same net,
  /// they are considered part of the same electrical network. In other words, pads with nets of the same name are
  /// connected to each other.
  final KiCadPCBNet? net;

  /// Creates a `ComponentPad` instance.
  KiCadComponentPad({
    required this.code,
    required this.type,
    required this.net,
  });

  /// Factory constructor that creates a `ComponentPad` instance from a parsed S-Expression.
  ///
  /// KiCAD stores pad definitions in an S-Expression format. The `fromSExpr` method processes this structure and
  /// extracts:
  ///
  /// - The pad number.
  /// - The pad type.
  /// - The net connection associated with the pad.
  factory KiCadComponentPad.fromSExpr(List<dynamic> data) {
    // Get the pad number of the component pad and convert it to an integer. The pad number is the second element
    // in the S-Expression list.
    final int? code = int.tryParse(data[1] as String);

    // Get the pad type from the S-Expression data. If the pad has a code, the pad type will be the third element
    // in the array. Otherwise, it will be the second element.
    final String type = code != null ? data[2] as String : data[1] as String;

    // Get the net array from the S-Expression data. The net array is the first element for which the first element
    // is the string 'net'.
    final List<dynamic>? netData = data.firstWhereOrNull((dynamic element) => element is List && element.first == 'net') as List<dynamic>?;
    // Convert the net data to a KiCadPCBNet instance.
    final KiCadPCBNet? net = netData != null ? KiCadPCBNet.fromSExpr(netData) : null;

    return KiCadComponentPad(
      code: code,
      type: type,
      net: net,
    );
  }
}
