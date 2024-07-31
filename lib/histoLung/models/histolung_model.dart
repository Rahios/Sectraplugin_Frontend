// MODEL
// Contains the Histolung class which is used to convert JSON to object.
// ROLE : Stores core data to be displayed in the Histolung page.
import 'dart:convert';
import 'dart:typed_data';

class HistolungModel
{
  // ATTRIBUTES
  final String    prediction;
  final Uint8List heatmap;

  // CONSTRUCTOR
  HistolungModel({
    required this.prediction, 
    required this.heatmap});

  // FACTORY TO CONVERT JSON TO OBJECT
  factory HistolungModel.fromJson(Map<String, dynamic> json) // Map is a collection of key-value pairs
  {
    // Use empty string if 'prediction' is null
    // ?? is used to return the value of the attribute if it is not null, otherwise return an empty string
    String prediction = json['prediction'] ?? '';
    
    print('Prediction: $prediction');
    
    // Use empty string if 'heatmap' is null
    Uint8List heatmap = base64Decode(json['heatmap'] ?? '');
    print('Heatmap: $heatmap');
    
    return HistolungModel(
      // json['Key'] is used to access the value of the attribute in JSON
      prediction: prediction,
      heatmap: heatmap, // Convert Base64 string to Uint8List
    );
  }

  // METHOD TO CONVERT OBJECT TO JSON
  // Map<String, dynamic> is used to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'Prediction': prediction,
      'Heatmap': base64Encode(heatmap), // Convert Uint8List to Base64 string
    };
  }
}
