// lib/models/histolung_model.dart

// MODEL
// Contains the Histolung class which is used to convert JSON to object.
// ROLE : Stores core data to be displayed in the Histolung page.
class HistolungModel
{
  // ATTRIBUTES
  final String prediction;
  final String heatmap; // Stores in base64 format as string

  // CONSTRUCTOR
  HistolungModel({
    required this.prediction, 
    required this.heatmap});

  // FACTORY TO CONVERT JSON TO OBJECT
  factory HistolungModel.fromJson(Map<String, dynamic> json) // Map is a collection of key-value pairs
  {
    return HistolungModel(
      // json['Key'] is used to access the value of the attribute in JSON
      prediction: json['Prediction'],
      heatmap: json['Heatmap'],
    );
  }
}
