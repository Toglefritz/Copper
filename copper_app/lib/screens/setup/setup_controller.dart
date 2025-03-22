import 'package:copper_app/screens/home/home_route.dart';
import 'package:copper_app/screens/setup/setup_route.dart';
import 'package:copper_app/services/database/database_service.dart';
import 'package:copper_app/services/kicad_parser/kicad_pcb_design.dart';
import 'package:flutter/material.dart';
import 'setup_view.dart';

/// Controller for the [SetupRoute].
class SetupController extends State<SetupRoute> {
  @override
  void initState() {
    // Get a list of projects for the current user.
    _getProjects();

    super.initState();
  }

  /// Gets a list of projects for the current user.
  Future<void> _getProjects() async {
    List<KiCadPCBDesign> designs = [];
    try {
      designs = await DatabaseService().getDesigns();
    }
    catch (e) {
      debugPrint('Failed to get projects with error, $e');
    }

    // Navigate to the home screen.
    _navigateToHome(designs);
  }

  /// Navigates to the home screen.
  void _navigateToHome(List<KiCadPCBDesign> designs) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (context) => HomeRoute(
          designs: designs,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const SetupView();
}
