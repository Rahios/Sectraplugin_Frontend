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
  final String baseUrl = 'https://vlbeltbsectra.hevs.ch/api/Histolung';

  // Interact with the API to analyze the image
  Future<HistolungModel> analyzeImage(String imageName) async
  {
    print('CONTROLLER - Analyzing image: $imageName');

    try
    {
      // Send a POST request to the API
      final response = await http.post(
        Uri.parse('$baseUrl/AnalyseImage'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'ImageName': imageName}), //Same 'ImageName' param name as the API expects in the request body
      ) // Set a timeout for the request
          .timeout(const Duration(minutes: 4),
          onTimeout: () {
            String message = 'Connection timed out, operation took too long';
            print(message);
            throw Exception(message);
          });


      print('Response status: ${response.statusCode}');

      // wait some more time before trying again to retrieve the result
      if (response.statusCode == 404) 
      {
        // ToDo : The timeout is not respected : This is a temporary solution to handle the timeout issue.
        //  the request is not interrupted after 4 minutes. It breaks sooner with a 404 error.
        // So the temproray solution is to retry after 40 seconds and then every 10 seconds for 3 minutes.
        // The final solution is to make a POST that will send the operation to the backend.
        // A wait to wait that the operation is finished and then a GET to retrieve the result.
        return await retrieveDelayed();
      }

      if (response.statusCode == 200)
      {
        print('Analyzing image retrieved successfully');
        print('Response body: ${response.body}');
        return HistolungModel.fromJson(json.decode(response.body));
      }
      else
      {
        throw Exception('Failed to analyze image. Status code not == 200');
      }
    }
    catch (e)
    {
      print('Error analyzing image: $e');
      throw Exception('Failed to analyze image');
    }
  }

  Future<HistolungModel> retrieveDelayed() async {
    print('Image not found, waiting 40 seconds before retrying');
    
    await Future.delayed(const Duration(seconds: 40));
    
    // Initialize a timer to retry for 3 minutes
    int elapsedSeconds = 0;
    const int retryInterval = 10;
    const int maxRetries = 18; // 3 minutes (180 seconds) / 10 seconds per retry
    
    // Retry every 10 seconds until the max number of retries is reached or the image is found
    while (elapsedSeconds < maxRetries * retryInterval)
    {
      await Future.delayed(const Duration(seconds: retryInterval));
      try
      {
        HistolungModel latestAnalysis = await getLastAnalysis();
        if (latestAnalysis.prediction.isNotEmpty)
        {
          return latestAnalysis;
        }
      }
      catch (e)
      {
        print('Retrying... Elapsed time: $elapsedSeconds seconds');
      }
    
      elapsedSeconds += retryInterval;
    }
    
    throw Exception('Failed to retrieve image after multiple retries');
  }


  // Download the latest analysis result from the API
  Future<HistolungModel> getLastAnalysis() async
  {
    print('CONTROLLER - Downloading latest analysis');
    try
    {
      print('Downloading heatmap');
      final response = await http.get(Uri.parse('$baseUrl/GetLatestAnalysis'));

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200)
      {
        print('Response body: ${response.body}');
        return HistolungModel.fromJson(json.decode(response.body));

      }
      else {
        throw Exception('Failed to load the latest Analysis. Status code not == 200');
      }
    }
    catch (e)
    {
      print('Error loading heatmap: $e');
      throw Exception('Failed to load heatmap');
    }
  }


  // Download the latest heatmap
  Future<HistolungModel> getHeatmap() async
  {
    print('CONTROLLER - Downloading heatmap');
    try
    {
      print('Downloading heatmap');
      final response = await http.get(Uri.parse('$baseUrl/GetHeatmap'));

      print('Response status: ${response.statusCode}');
      print('Heatmap retrieved successfully ${response.bodyBytes}');

      if (response.statusCode == 200)
      {
        print('Heatmap retrieved successfully');

        // Instanciate a new HistolungModel object with the heatmap data and a null prediction value
        return HistolungModel(
            heatmap: response.bodyBytes,
            prediction: '');

      } else {
        throw Exception('Failed to load heatmap. Status code not == 200');
      }
    }
    catch (e)
    {
      print('Error loading heatmap: $e');
      throw Exception('Failed to load heatmap');
    }

  }

  Future<List<String>> scanImagesFolder() async
  {
    print('CONTROLLER - Scanning images folder');
    try {
      final response = await http.get(Uri.parse('$baseUrl/GetImagesList'));

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        List<dynamic> jsonResponse = json.decode(response.body);
        List<String> imageList = List<String>.from(jsonResponse);
        print('Images list retrieved successfully');
        print('Images list: $imageList');
        return imageList;
      }
      else {
        throw Exception('Failed to scan images folder. Status code not == 200');
      }
    }
    catch (e)
    {
      print('Error scanning images folder: $e');
      throw Exception('Failed to scan images folder');
    }

  }


}
