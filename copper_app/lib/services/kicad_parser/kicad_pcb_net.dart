import 'package:copper_app/services/kicad_parser/kicad_entity.dart';

/// Represents a PCB Net (Electrical Connection) within a KiCAD PCB design.
///
/// In KiCAD, a **net** represents an electrical connection between components. Nets define how different circuit
/// elements (such as resistors, capacitors, and ICs) are connected using copper traces. Each net is assigned a
/// **unique code** and a **name**, which helps in identifying electrical paths within the PCB.
///
/// ## Purpose:
/// - Stores information about electrical connections between different PCB components.
/// - Provides an easy way to reference and track connections when analyzing PCB designs.
/// - Enables circuit validation and optimization by identifying connected components.
///
/// ## Usage:
/// The `KiCadPCBNet` class is instantiated using the `PCBNet.fromSExpr` factory constructor, which extracts net
/// information from the parsed S-Expression data of a KiCad PCB file. It is used within the `PCBDesign` class to
/// organize all electrical connections in the design.
class KiCadPCBNet extends KiCadEntity {
  /// The unique numerical identifier for the net.
  ///
  /// KiCAD assigns each net a numerical code, which serves as an internal reference. This code is used to differentiate
  /// between different nets and helps in organizing electrical connections.
  final int code;

  /// The name of the net.
  ///
  /// The name of the net represents the electrical signal or connection name within the circuit. Common examples
  /// include:
  ///
  /// - `"VCC"` (Power Supply)
  /// - `"GND"` (Ground)
  /// - `"SCL"` (Clock signal for I2C communication)
  /// - `"SIGNAL1"` (Custom signal name for a specific connection)
  ///
  /// Named nets make circuit analysis easier by providing meaningful identifiers instead of numerical codes.
  final String? name;

  /// Creates a new `KiCadPCBNet` instance with the specified code and name.
  ///
  /// This constructor is mainly used when manually defining a net for testing or creating a PCB representation.
  KiCadPCBNet({
    required this.code,
    required this.name,
  });

  /// Factory constructor that creates a `KiCadPCBNet` instance from a parsed S-Expression.
  ///
  /// KiCAD stores net definitions in an S-Expression format. The `fromSExpr` method processes this structure and
  /// creates a structured representation of the net.
  ///
  /// This method is used by the `KiCadPCBDesign` class to create a structured representation of all electrical
  /// connections in the PCB layout.
  factory KiCadPCBNet.fromSExpr(List<dynamic> data) {
    // Get the code of the net. This is the second element in the list converted to an integer.
    final int code = int.parse(data[1] as String);

    // Get the name of the net. This is the third element in the list.
    final String? name = data.length > 2 ? data[2] as String? : null;

    return KiCadPCBNet(
      code: code,
      name: name,
    );
  }

  /// Returns a `KiCadPCBNet` object from a JSON representation.
  factory KiCadPCBNet.fromJson(Map<String, dynamic> json) {
    return KiCadPCBNet(
      code: json['code'] as int,
      name: json['name'] as String?,
    );
  }

  /// Converts the `KiCadPCBNet` object to a JSON representation.
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
    };
  }
}
