import 'package:copper_app/services/kicad_parser/kicad_entity.dart';

import 'kicad_layer.dart';

/// Represents a single layer within a KiCAD PCB design.
///
/// In KiCAD, a PCB design consists of multiple layers, each serving a specific purpose. Layers include copper
/// layers (`F.Cu`, `B.Cu`), silkscreen layers (`F.SilkS`, `B.SilkS`), solder mask layers (`F.Mask`, `B.Mask`), and
/// other user-defined layers. Each layer in the design is assigned an index, a name, and a type.
///
/// ## Purpose:
/// - This class provides a structured representation of a PCB layer.
/// - It allows the parser to store and retrieve layer information from the `.kicad_pcb` file.
/// - It helps in performing analysis and visualization of layer-based design elements.
///
/// ## Usage:
/// The `KiCadPCBLayer` class is instantiated via the `KiCadPCBLayer.fromSExpr` factory method, which takes an
/// S-Expression representation of a layer and converts it into a structured Dart object. It is used within the
/// `KiCadPCBDesign` class to manage the full list of layers in a KiCAD design.
class KiCadPCBLayer extends KiCadEntity {
  /// The numerical index of the layer as defined in the KiCAD design file.
  ///
  /// This index is used internally by KiCAD to reference different layers within the PCB stackup.
  ///
  /// Example:
  ///
  /// - `0` represents the front copper layer (`F.Cu`).
  /// - `1` represents the back copper layer (`B.Cu`).
  /// - Other numbers correspond to additional layers such as silkscreen, mask, and user-defined layers.
  final int index;

  /// The name of the layer as defined in the KiCAD design file.
  ///
  /// This name corresponds to KiCAD's naming convention, such as:
  ///
  /// - `"F.Cu"` (Front Copper)
  /// - `"B.Cu"` (Back Copper)
  /// - `"F.SilkS"` (Front Silkscreen)
  /// - `"B.Mask"` (Back Solder Mask)
  final KiCadLayer? type;

  /// The purpose of layer, which specifies its role in the PCB design.
  ///
  /// The type may indicate whether the layer is for signal routing, power distribution, or user-defined purposes.
  ///
  /// - `"signal"`: Used for electrical connections and traces.
  /// - `"user"`: A custom user-defined layer.
  /// - `"unknown"`: Default type if the layer type is not explicitly defined in the design file.
  final String purpose;

  /// Constructs a `KiCadPCBLayer` object with the given index, type, and purpose.
  ///
  /// This constructor is typically used when manually creating a PCB layer representation.
  KiCadPCBLayer({
    required this.index,
    required this.type,
    required this.purpose,
  });

  /// Factory constructor that creates a `KiCadPCBLayer` instance from a parsed S-Expression list.
  ///
  /// KiCAD stores layer definitions in an S-Expression format, such as:
  ///
  /// ```lisp
  /// (layers
  ///   (0 "F.Cu" signal)
  ///   (1 "B.Cu" signal)
  ///   (5 "F.SilkS" user)
  /// )
  /// ```
  ///
  /// The `fromSExpr` method processes this list and extracts the relevant information.
  ///
  /// - `data[0]`: The index of the layer (as a string, converted to an integer).
  /// - `data[1]`: The name of the layer (e.g., `"F.Cu"`).
  /// - `data[2]`: The type of the layer (e.g., `"signal"`), defaulting to `"unknown"` if not provided.
  ///
  /// This method is used by the `KiCadPCBDesign` class when constructing the layer list.
  factory KiCadPCBLayer.fromSExpr(List<dynamic> data) {
    // Get the layer index from the first element of the list. Convert the index from a string to an integer.
    final int layerIndex = int.parse(data[0] as String);

    // Get the layer type from the second element of the list.
    final KiCadLayer? layerType = data.length > 1 ? KiCadLayer.fromName(data[1] as String) : null;

    // Get the layer purpose from the third element of the list.
    final String layerPurpose = data.length > 2 ? data[2] as String : 'unknown';

    return KiCadPCBLayer(
      index: layerIndex,
      type: layerType,
      purpose: layerPurpose,
    );
  }

  /// Returns a [KiCadPCBLayer] object from a JSON representation.
  factory KiCadPCBLayer.fromJson(Map<String, dynamic> json) {
    return KiCadPCBLayer(
      index: json['index'] as int,
      type: KiCadLayer.fromName(json['type'] as String),
      purpose: json['purpose'] as String,
    );
  }

  /// Converts the [KiCadPCBLayer] object to a JSON representation.
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'type': type?.name,
      'purpose': purpose,
    };
  }
}
