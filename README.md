# Copper

<img src="assets/copper_icon_48.png"/>

**Copper** is a web application built in Flutter that helps engineers analyze and improve their KiCad PCB designs. By parsing PCB design files, the application extracts key design information and uses Azure AI Services to provide insights, detect errors, and suggest optimizations.

## Features
- 📁 **Upload and Parse KiCad PCB Files** – Extracts design details from PCB design files (currently .kicad_pcb) files.
- 🔍 **Trace & Routing Analysis** – Evaluates trace widths, clearance, and routing efficiency.
- ⚡ **Power & Signal Integrity Insights** – Detects potential issues in power distribution and signal paths.
- 📊 **Manufacturability Review** – Ensures the PCB design meets fabrication constraints.
- 🤖 **AI-Powered Feedback** – Uses Azure AI Services for advanced analysis and recommendations.
- 📄 **Detailed Reports** – Generates structured feedback for engineers to refine their designs.

## Technology Stack

### Frontend:
- **Flutter Web** – Provides a responsive UI for analyzing PCB designs.
- **Dart** – Powers the application logic and interactions.

### Backend & AI Services:
- **Azure AI Services** – Performs AI-driven analysis on PCB design data.
- **Azure Functions** – Handles backend processing for file parsing and AI requests.
- **Azure Blob Storage** – Stores uploaded .kicad_pcb files and processed reports.

## Project Workflow

1️⃣ **User Uploads a KiCad PCB File**
The user selects a PCB design file (`.kicad_pcb`) file and uploads it to the application.

2️⃣ **Parsing the PCB File**
The application extracts key data from the file, including:

- Components & Footprints
- Traces, Vias & Copper Zones
- Netlists & Layer Information
- Design Rules & Constraints

This parsed data is stored in an internal representation that allows for structured analysis.

3️⃣ **AI-Powered Analysis with Azure AI Services**
Once the design data is structured, the application sends relevant information to Azure AI Services for further analysis. These services provide:

✅ Design Rule & Electrical Rule Compliance
- Identifies DRC & ERC violations using AI-assisted pattern recognition.
- Suggests potential fixes based on best practices.

✅ Trace & Routing Evaluation
- Detects bottlenecks, excessive via use, or unnecessary trace complexity.
- Provides insights into trace width adequacy for expected current loads.

✅ Power & Signal Integrity Analysis
- Checks ground planes, power distribution efficiency, and potential EMI issues.
- Suggests improvements for high-speed signal routing and differential pairs.

✅ Manufacturability & Assembly Review
- Uses AI to detect potential fabrication issues (e.g., silkscreen misalignment, solder mask clearance).
- Ensures the design aligns with common PCB manufacturing constraints.

4️⃣ **Generating a Report**
The application compiles the analysis results into a detailed report with:

- Issue Summaries & Severity Ratings
- Recommendations & Fixes
- Visual Annotations (where applicable)

5️⃣ **User Review & Iteration**
The user reviews the findings and applies necessary changes to their design in KiCad.

## Installation & Development

### Prerequisites:
- Flutter (latest stable version)
- Azure Account with AI Services configured

### Setup Instructions:

1. **Clone the repository**:

```sh
git clone https://github.com/Toglefritz/Circuit-Check
cd circuit-check
```

2. **Install dependencies**:

```sh
flutter pub get
flutter gen-l10n
```

3. **Set up environment variables for Azure services**:
// TODO: Document setup for Azure functions

4. **Run the application**:

```sh
flutter run -d chrome
```

## Roadmap & Future Enhancements

🚀 Upcoming Features:
- **Automated Fix Suggestions** – Apply design fixes directly from Copper.
- **Real-Time KiCad Plugin** – Direct integration with KiCad for instant feedback.
- **Custom Rule Configuration** – Allow users to define custom DRC/ERC checks.

## Contributing
Contributions to this project are welcomed and greatly appreciated!

1. Fork the repository
2. Create a feature branch (`feature-new-analysis`)
3. Commit your changes
4. Submit a pull request

## License
This project is licensed under the MIT License. See *LICENSE* for details.

## Disclaimer
In the creation of this application, artificial intelligence (AI) tools have been utilized. These tools have assisted in various stages of the plugin's development, from initial code generation to the optimization of algorithms.

It is emphasized that the AI's contributions have been thoroughly overseen. Each segment of AI-assisted code has undergone meticulous scrutiny to ensure adherence to high standards of quality, reliability, and performance. This scrutiny was conducted by the sole developer responsible for the app's creation.

Rigorous testing has been applied to all AI-suggested outputs, encompassing a wide array of conditions and use cases. Modifications have been implemented where necessary, ensuring that the AI's contributions are well-suited to the specific requirements and limitations inherent in the technologies related to this app's functionality.

Commitment to the apps's accuracy and functionality is paramount, and feedback or issue reports from users are invited to facilitate continuous improvement.

It is to be understood that this app, like all software, is subject to evolution over time. The developer is dedicated to its progressive refinement and is actively working to surpass the expectations of the community.