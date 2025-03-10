/// Represents a response from the LLM for analysis of a PCB design.
///
/// This app uses an LLM system to analyze a PCB design based on information about a design and a prompt provided by
/// the user. This class represents the response from the LLM.
class AnalysisResponse {
  /// The prompt submitted by the user to the LLM.
  final String prompt;

  /// The response data from the LLM.
  ///
  /// The LLM will respond to requests to perform an analysis of a PCB design with a Markdown string. This string
  /// contains the analysis of the PCB design based on the prompt and the information provided.
  final String responseData;

  /// A timestamp for when the response was received.
  final DateTime timestamp;

  /// Creates an instance of [AnalysisResponse].
 AnalysisResponse({
    required this.prompt,
    required this.responseData,
    DateTime? receivedTime,
  }) : timestamp = receivedTime ?? DateTime.now();
}
