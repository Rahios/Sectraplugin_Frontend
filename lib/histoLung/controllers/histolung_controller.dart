// lib/controllers/histolung_controller.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/histolung_model.dart';

class HistolungController
{
  final String baseUrl = 'https://153.109.124.207:8087/api/Histolung';

  // Interact with the API to analyze the image
  Future<Histolung> analyzeImage(String imageName) async
  {
    // Send a POST request to the API
    final response = await http.post(
      Uri.parse('$baseUrl/AnalyseImage'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'ImageName': imageName}),
    );

    if (response.statusCode == 200)
    {
      return Histolung.fromJson(json.decode(response.body));
    }
    else
    {
      throw Exception('Failed to analyze image');
    }
  }
}
