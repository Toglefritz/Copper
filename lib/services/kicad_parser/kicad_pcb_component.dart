import 'package:circuit_check_app/services/kicad_parser/kicad_component_pad.dart';
import 'package:circuit_check_app/services/kicad_parser/kicad_entity.dart';
import 'package:circuit_check_app/services/kicad_parser/kicad_layer.dart';
import 'package:collection/collection.dart';

import 'kicad_pcb_component_position.dart';

/// Represents a single component (a.k.a. footprint or module) within a KiCAD PCB design.
///
/// In KiCAD, components such as resistors, capacitors, integrated circuits, and connectors are represented as
/// **components/footprints/modules**. Each component contains data such as its name, position on the board, and the
/// layer on which it is placed. This class provides a structured way to store and interact with component data
/// extracted from a KiCAD PCB file.
///
/// ## Purpose:
/// - Stores detailed information about each component in the PCB layout.
/// - Provides an interface for retrieving component-specific attributes like position (`x`, `y`) and the layer to which
///   it belongs.
/// - Acts as a building block in the parsed representation of the PCB design.
///
/// ## Usage:
/// The `KiCadPCBComponent` class is instantiated through the `KiCadPCBComponent.fromSExpr` factory method, which
/// processes parsed S-Expression data extracted from the `.kicad_pcb` file. It is primarily used by the
/// `KiCadPCBDesign` class to manage and access all components in the design.
// ignore_for_file: avoid_dynamic_calls
class KiCadPCBComponent extends KiCadEntity {
  /// The reference name of the component (e.g., `"R1"`, `"C3"`, `"U2"`).
  ///
  /// In KiCAD, each footprint has a unique reference name used to identify it in the schematic and PCB layout.
  final String name;

  /// The layer on which the module is placed (e.g., `"F.Cu"` for the front copper layer).
  ///
  /// Components can be placed on different layers of the PCB. Common values include:
  ///
  /// - `"F.Cu"`: Front copper layer (top side of the board).
  /// - `"B.Cu"`: Back copper layer (bottom side of the board).
  /// - `"F.SilkS"`: Front silkscreen layer (used for component labels and graphics).
  final KiCadLayer? layer;

  /// A list of pads associated with the component.
  ///
  /// Each component may have multiple pads that are used to connect the component to the PCB. This list stores
  /// the pads associated with the component, including the pad number, type, and net connection. The net connection
  /// for each pad is particularly important for understanding how different components in the PCB design are
  /// electrically connected.
  final List<KiCadComponentPad> pads;

  /// The position and rotation of the component on the PCB.
  ///
  /// The `x` and `y` coordinates represent the location of the component on the PCB layout. The `rotation` angle
  /// specifies the orientation of the component.
  final KiCadPCBComponentPosition position;

  /// The description of the component.
  ///
  /// This field is optional and may contain additional information about the component, such as the manufacturer,
  /// part number, or other details.
  final String? description;

  /// A reference to the component's footprint on the PCB.
  ///
  /// Components in a PCB design typically, but optionally, have a reference to the footprint used to represent
  /// the component on the board. This reference can be used to identify the specific footprint used for the component
  /// (e.g. "UI" or "R1"). These references are useful for populating the BOM (Bill of Materials) and for placing
  /// components on the board during assembly.
  final String? reference;

  /// The vale of the component.
  ///
  /// This field is optional and may contain a value associated with the component, such as a resistor value
  /// (e.g. "4.7k") or capacitor value (e.g. "0.1uF). This value is typically used to specify the electrical
  /// characteristics of the component.
  final String? value;

  /// Creates a new `KiCadPCBComponent` instance with the specified properties.
  ///
  /// This constructor is primarily used when manually defining a component, such as for testing or creating
  /// a module from a structured representation.
  KiCadPCBComponent({
    required this.name,
    required this.position,
    required this.layer,
    required this.pads,
    this.description,
    this.reference,
    this.value,
  });

  /// Factory constructor that creates a `KiCadPCBComponent` instance from a parsed S-Expression.
  ///
  /// KiCAD stores footprint definitions in an S-Expression format. The `fromSExpr` method processes this structure
  /// and extracts relevant attributes.
  factory KiCadPCBComponent.fromSExpr(List<dynamic> data) {
    // Get the name of the component (e.g., "WS2812B"). This is the second element in the list.
    final name = data[1] as String;

    // Get the layer identifier string. This is the first element for which the first element is the string 'layer'.
    final List<dynamic>? layerElement =
        data.firstWhereOrNull((dynamic element) => element is List && element.first == 'layer') as List<dynamic>?;
    // Get the KiCadLayer object from the layer data.
    final KiCadLayer? layer =
        layerElement != null && layerElement.length > 1 ? KiCadLayer.fromName(layerElement[1] as String) : null;

    // Get the position and rotation information for the component. This is the first element for which the first
    // element is the string 'at'.
    final List<dynamic>? positionElement =
        data.firstWhereOrNull((dynamic element) => element is List && element.first == 'at') as List<dynamic>?;
    // Convert the position data into a KiCadPCBComponentPosition object.
    final KiCadPCBComponentPosition position = KiCadPCBComponentPosition.fromSExpr(positionElement ?? <dynamic>[]);

    // Get the description of the component. This is the first element for which the first element is the string 'descr'.
    final List<dynamic>? descriptionElement =
        data.firstWhereOrNull((dynamic element) => element is List && element.first == 'descr') as List<dynamic>?;
    // Get the description string from the description data.
    final String? description = descriptionElement != null && descriptionElement.length > 1 ? descriptionElement[1] as String : null;

    // Get a list of properties for the component. This is a list of elements in the array for which the first element
    // is the string 'property'. There will typically be multiple 'property' elements in the array.
    final List<List<dynamic>> propertyElements = data.whereType<List<dynamic>>().where((List<dynamic> element) => element.first == 'property').toList();

    // Get the reference property of the component. This is the first element in the list for which the second element
    // is the string 'Reference'.
    final List<dynamic>? referenceElement = propertyElements.firstWhereOrNull((List<dynamic> element) => element.length > 2 && element[1] == 'Reference');
    // Get the reference property value from the reference element.
    final String? reference = referenceElement != null && referenceElement.length > 2 ? referenceElement[2] as String : null;

    // Get the value property of the component. This is the first element in the list for which the second element
    // is the string 'Value'.
    final List<dynamic>? valueElement = propertyElements.firstWhereOrNull((List<dynamic> element) => element.length > 2 && element[1] == 'Value');
    // Get the value property value from the value element.
    final String? value = valueElement != null && valueElement.length > 2 && valueElement[2] is String ? valueElement[2] as String : null;

    // Get the list of pads associated with the component. This is a list of elements in the array for which the first
    // element is the string 'pad'. There may be multiple 'pad' elements in the array.
    final List<List<dynamic>> padElements = data.whereType<List<dynamic>>().where((List<dynamic> element) => element.first == 'pad').toList();
    // Convert the pad data into a list of KiCadComponentPad objects.
    final List<KiCadComponentPad> pads = padElements.map(KiCadComponentPad.fromSExpr).toList();

    return KiCadPCBComponent(
      name: name,
      layer: layer,
      position: position,
      description: description,
      reference: reference,
      value: value,
      pads: pads,
    );
  }
}
