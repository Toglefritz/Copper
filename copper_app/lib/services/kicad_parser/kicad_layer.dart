import 'package:collection/collection.dart';

/// An enumeration of the layers in a KiCAD PCB file.
// ignore_for_file: public_member_api_docs
enum KiCadLayer {
  fCu(id: 'F.Cu', description: 'Front copper layer'),
  in1Cu(id: 'In1.Cu', description: 'Inner copper layer 1'),
  in2Cu(id: 'In2.Cu', description: 'Inner copper layer 2'),
  in3Cu(id: 'In3.Cu', description: 'Inner copper layer 3'),
  in4Cu(id: 'In4.Cu', description: 'Inner copper layer 4'),
  in5Cu(id: 'In5.Cu', description: 'Inner copper layer 5'),
  in6Cu(id: 'In6.Cu', description: 'Inner copper layer 6'),
  in7Cu(id: 'In7.Cu', description: 'Inner copper layer 7'),
  in8Cu(id: 'In8.Cu', description: 'Inner copper layer 8'),
  in9Cu(id: 'In9.Cu', description: 'Inner copper layer 9'),
  in10Cu(id: 'In10.Cu', description: 'Inner copper layer 10'),
  in11Cu(id: 'In11.Cu', description: 'Inner copper layer 11'),
  in12Cu(id: 'In12.Cu', description: 'Inner copper layer 12'),
  in13Cu(id: 'In13.Cu', description: 'Inner copper layer 13'),
  in14Cu(id: 'In14.Cu', description: 'Inner copper layer 14'),
  in15Cu(id: 'In15.Cu', description: 'Inner copper layer 15'),
  in16Cu(id: 'In16.Cu', description: 'Inner copper layer 16'),
  in17Cu(id: 'In17.Cu', description: 'Inner copper layer 17'),
  in18Cu(id: 'In18.Cu', description: 'Inner copper layer 18'),
  in19Cu(id: 'In19.Cu', description: 'Inner copper layer 19'),
  in20Cu(id: 'In20.Cu', description: 'Inner copper layer 20'),
  in21Cu(id: 'In21.Cu', description: 'Inner copper layer 21'),
  in22Cu(id: 'In22.Cu', description: 'Inner copper layer 22'),
  in23Cu(id: 'In23.Cu', description: 'Inner copper layer 23'),
  in24Cu(id: 'In24.Cu', description: 'Inner copper layer 24'),
  in25Cu(id: 'In25.Cu', description: 'Inner copper layer 25'),
  in26Cu(id: 'In26.Cu', description: 'Inner copper layer 26'),
  in27Cu(id: 'In27.Cu', description: 'Inner copper layer 27'),
  in28Cu(id: 'In28.Cu', description: 'Inner copper layer 28'),
  in29Cu(id: 'In29.Cu', description: 'Inner copper layer 29'),
  in30Cu(id: 'In30.Cu', description: 'Inner copper layer 30'),
  bcu(id: 'B.Cu', description: 'Back copper layer'),
  bAdhes(id: 'B.Adhes', description: 'Back adhesive layer'),
  fAdhes(id: 'F.Adhes', description: 'Front adhesive layer'),
  bPaste(id: 'B.Paste', description: 'Back paste layer'),
  fPaste(id: 'F.Paste', description: 'Front paste layer'),
  bSilkS(id: 'B.SilkS', description: 'Back silkscreen layer'),
  fSilkS(id: 'F.SilkS', description: 'Front silkscreen layer'),
  bMask(id: 'B.Mask', description: 'Back solder mask'),
  fMask(id: 'F.Mask', description: 'Front solder mask'),
  dwgsUser(id: 'Dwgs.User', description: 'User drawing layer'),
  cmtsUser(id: 'Cmts.User', description: 'User comments layer'),
  eco1User(id: 'Eco1.User', description: 'User engineering change order layer 1'),
  eco2User(id: 'Eco2.User', description: 'User engineering change order layer 2'),
  edgeCuts(id: 'Edge.Cuts', description: 'Board outline layer'),
  fCrtYd(id: 'F.CrtYd', description: 'Front courtyard layer'),
  bCrtYd(id: 'B.CrtYd', description: 'Back courtyard layer'),
  user1(id: 'User.1', description: 'User definable layer 1'),
  user2(id: 'User.2', description: 'User definable layer 2'),
  user3(id: 'User.3', description: 'User definable layer 3'),
  user4(id: 'User.4', description: 'User definable layer 4'),
  user5(id: 'User.5', description: 'User definable layer 5'),
  user6(id: 'User.6', description: 'User definable layer 6'),
  user7(id: 'User.7', description: 'User definable layer 7'),
  user8(id: 'User.8', description: 'User definable layer 8'),
  user9(id: 'User.9', description: 'User definable layer 9');

  /// The identifier for the layer in KiCAD PCB design files using S-Expressions.
  final String id;

  /// The layer description used in KiCAD PCB design files, according to [https://dev-docs.kicad.org/en/file-formats/sexpr-intro/](https://dev-docs.kicad.org/en/file-formats/sexpr-intro/).
  final String description;

  /// Creates a [KiCadLayer] instance with the specified ID and description.
  const KiCadLayer({
    required this.id,
    required this.description,
  });

  /// Returns the [KiCadLayer] enum value corresponding to the given layer type ID string.
  static KiCadLayer? fromName(String name) =>
      KiCadLayer.values.firstWhereOrNull((KiCadLayer layer) => layer.id == name);
}
