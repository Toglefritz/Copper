import 'dart:convert';

import 'package:copper_app/services/kicad_parser/kicad_pcb_design.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../authentication/authentication_service.dart';

/// A service offering methods for interacting with the Copper backend database.
///
/// Copper allows users to keep track of the PCB design projects by saving information to and retrieving information
/// from an Azure Cosmos DB database. This service provides methods for saving and retrieving PCB design information
/// from the database.
class DatabaseService {
  /// The base URL used for all requests to the Copper backend.
  final String _baseUrl = 'https://copperapp.azurewebsites.net';

  /// Retrieves a list of all PCB design projects saved in the database for the current user.
  Future<List<KiCadPCBDesign>> getDesigns() async {
    // Send the request to the Copper backend to retrieve the list of PCB designs.
    try {
      // Get a Bearer token from the authenticated session.
      final String? bearerToken = AuthenticationService.cachedToken?.rawIdToken;

      // If there is no token, throw an error.
      if (bearerToken == null) {
        throw Exception('No bearer token available for getting PCB designs');
      }

      final Response response = await get(
        Uri.parse('$_baseUrl/readUserItems'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
      );

      // Check if the response is successful.
      if (response.statusCode == 200) {
        // Get the response content.
        final String responseContent = response.body;

        // Parse the response content into a list of PCB designs.
        final List<dynamic> data = json.decode(responseContent) as List<dynamic>;

        final List<KiCadPCBDesign> designs = [];
        for (final dynamic designData in data) {
          final KiCadPCBDesign design = KiCadPCBDesign.fromJson(designData as Map<String, dynamic>);
          designs.add(design);
        }

        return designs;
      } else {
        throw Exception('Failed to send prompt to LLM with status code, ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Failed to create PCB design document with error, $e');

      rethrow;
    }
  }

  /// Saves a PCB design project to the database.
  Future<void> saveDesign(KiCadPCBDesign design) async {
    // Send the request to the Copper backend to save the PCB design.
    try {
      // Get a Bearer token from the authenticated session.
      final String? bearerToken = AuthenticationService.cachedToken?.rawIdToken;

      // If there is no token, throw an error.
      if (bearerToken == null) {
        throw Exception('No bearer token available for saving PCB design');
      }

      final Response response = await post(
        Uri.parse('$_baseUrl/createItem'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: json.encode(design.toJson()),
      );

      // Check if the response is successful.
      if (response.statusCode != 201) {
        throw Exception('Failed to save PCB design with status code, ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Failed to save PCB design with error, $e');

      rethrow;
    }
  }

  /// Updates the description of the PCB design project in the database.
  Future<void> updateDescription(String description) async {
    // Send the request to the Copper backend to update the PCB design description.
    try {
      // Get a Bearer token from the authenticated session.
      final String? bearerToken = AuthenticationService.cachedToken?.rawIdToken;

      // If there is no token, throw an error.
      if (bearerToken == null) {
        throw Exception('No bearer token available for updating PCB design description');
      }

      final Response response = await post(
        Uri.parse('$_baseUrl/updateItem'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: json.encode({
          'description': description,
        }),
      );

      // Check if the response is successful.
      if (response.statusCode != 200) {
        throw Exception('Failed to update PCB design description with status code, ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Failed to update PCB design description with error, $e');

      rethrow;
    }
  }
}
