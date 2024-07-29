// lib/models/histolung_model.dart

class Histolung
{
  // ATTRIBUTES
  final String prediction;
  final String heatmap;

  // CONSTRUCTOR
  Histolung({required this.prediction, required this.heatmap});

  // FACTORY TO CONVERT JSON TO OBJECT
  factory Histolung.fromJson(Map<String, dynamic> json)
  {
    return Histolung(
      prediction: json['Prediction'],
      heatmap: json['Heatmap'],
    );
  }
}
