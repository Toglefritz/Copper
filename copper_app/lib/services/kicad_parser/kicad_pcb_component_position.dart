/// Represents the position and rotation of a component on a KiCAD PCB.
///
/// The `KiCadPCBComponentPosition` class stores the X and Y coordinates of a component on a KiCAD PCB layout.
/// It also includes the rotation angle of the component, which is used to orient the component correctly.
class KiCadPCBComponentPosition {
  /// The X-coordinate of the component on the PCB layout.
  final double x;

  /// The Y-coordinate of the component on the PCB layout.
  final double y;

  /// The rotation angle of the component in degrees.
  final double rotation;

  /// Creates a new `KiCadPCBComponentPosition` instance with the specified coordinates and rotation.
  KiCadPCBComponentPosition({
    required this.x,
    required this.y,
    required this.rotation,
  });

  /// Factory constructor that creates a `KiCadPCBComponentPosition` instance from a parsed S-Expression list.
  factory KiCadPCBComponentPosition.fromSExpr(List<dynamic> data) {
    // Get the X-coordinate of the component. This is the second element in the list converted to a double.
    final double x = double.parse(data[1] as String);

    // Get the Y-coordinate of the component. This is the third element in the list converted to a double.
    final double y = double.parse(data[2] as String);

    // Get the rotation angle of the component. This is the fourth element in the list converted to a double. This
    // value is optional and defaults to 0.0 if not present.
    final double rotation = data.length > 3 ? double.parse(data[3] as String) : 0.0;

    return KiCadPCBComponentPosition(
      x: x,
      y: y,
      rotation: rotation,
    );
  }

  /// Returns a `KiCadPCBComponentPosition` object from a JSON representation.
  factory KiCadPCBComponentPosition.fromJson(Map<String, dynamic> json) {
    return KiCadPCBComponentPosition(
      x: json['x'] as double,
      y: json['y'] as double,
      rotation: json['rotation'] as double,
    );
  }

  /// Converts the `KiCadPCBComponentPosition` object to a JSON representation.
  Map<String, dynamic>  toJson() {
    return {
      'x': x,
      'y': y,
      'rotation': rotation,
    };
  }
}
