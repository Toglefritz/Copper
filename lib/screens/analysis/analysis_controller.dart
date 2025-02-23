import 'package:flutter/material.dart';
import 'analysis_route.dart';
import 'analysis_view.dart';

/// Controller for the [AnalysisRoute].
class AnalysisController extends State<AnalysisRoute> {
  @override
  void initState() {
    // Perform analysis of the PCB design.
    _analyzePCBDesign();

    super.initState();
  }

  /// Analyzes the PCB design.
  ///
  /// The process of analyzing a PCB design involves two high level steps:
  ///
  /// 1. A prompt to be sent to the LLM system is generated using information about the PCB designed parsed by the app.
  /// 2. The LLM system is prompted to perform an analysis of the PCB design and generates a report.
  ///
  /// This method is responsible for generating the prompt for the LLM system and sending it to the LLM system for
  /// analysis. The results of the analysis are then displayed to the user on the next screen.
  Future<void> _analyzePCBDesign() async {
    // Step 1: Generate a prompt for the LLM system.
    _generateLLMPrompt();

    // Step 2: Send the prompt to the LLM system and display the results.
    await _performAnalysis();

    // TODO(Toglefritz): Navigate to the report screen.
    //_navigateToReport(pcbDesign));
  }

  /// Builds a prompt for the LLM system.
  ///
  /// This method is responsible for generating a prompt for the LLM system based on the information about the PCB
  /// design parsed by the app.
  void _generateLLMPrompt() {
    // TODO(Toglefritz): Implement prompt generation.
  }

  /// Sends the prompt to the LLM system and displays the results.
  ///
  /// This method is responsible for sending the prompt to the LLM system and displaying the results of the analysis to
  /// the user.`
  Future<void> _performAnalysis() async {
    // TODO(Toglefritz): Implement analysis.
  }

  @override
  Widget build(BuildContext context) => AnalysisView(this);
}
