// lib/controllers/histolung_controller.dart

import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/histolung_model.dart';

// CONTROLLER
// This class is responsible for interacting with the backend API
// It sends requests to the API and processes the responses to be used by the UI
// ROLE : Communicate with the API and process the responses to update the model
// Implement the logic to interact with the API
class HistolungController
{
  final String baseUrl = 'https://153.109.124.207:8087/api/Histolung';

  // Interact with the API to analyze the image
  Future<HistolungModel> analyzeImage(String imageName) async
  {
    // Send a POST request to the API
    final response = await http.post(
      Uri.parse('$baseUrl/AnalyseImage'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'ImageName': imageName}),
    );

    if (response.statusCode == 200)
    {

      final responseBody = json.decode(response.body);

      // Decode the Base64 string from the response and convert it to a Uint8List
      String base64String = responseBody['Image'];

      return HistolungModel.fromJson(json.decode(response.body));
    }
    else
    {
      throw Exception('Failed to analyze image');
    }
  }

  // Download the latest heatmap
  Future<Uint8List> getHeatmap() async
  {
    final response = await http.get(Uri.parse('$baseUrl/GetHeatmap'));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load heatmap');
    }
  }
}
