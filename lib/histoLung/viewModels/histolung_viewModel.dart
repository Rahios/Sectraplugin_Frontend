// lib/viewmodels/histolung_viewmodel.dart

import 'package:flutter/foundation.dart';
import '../models/histolung_model.dart';
import '../controllers/histolung_controller.dart';

class HistolungViewModel extends ChangeNotifier
{

  final HistolungController controller;
  Histolung? _histolung;

  // CONSTRUCTOR
  HistolungViewModel({required this.controller});

  // GETTER
  Histolung? get histolung => _histolung;

  // SETTER
  Future<void> analyzeImage(String imageName) async
  {
    _histolung = await controller.analyzeImage(imageName);
    notifyListeners();
  }
}
