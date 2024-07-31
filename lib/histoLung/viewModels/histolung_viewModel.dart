// lib/viewmodels/histolung_viewmodel.dart

import 'package:flutter/foundation.dart';
import '../models/histolung_model.dart';
import '../controllers/histolung_controller.dart';

// VIEW MODEL
// This class is responsible for managing the state of the Histolung model.
// Extends ChangeNotifier to notify the listeners when the state changes.
// It interacts with the HistolungController to fetch the data and update the state.
// It notifies the listeners when the state changes.
// ROLE : - State Management of the Histolung model
//        - Fetch data from the controller
//        - Update the state of the model via the controller
//        - Notify the listeners in the UI when the state changes
// Implement the business logic of the application
class HistolungViewModel extends ChangeNotifier
{
  final HistolungController controller;
  HistolungModel? _histolungModel;
  Uint8List? _heatmap;
  bool _isLoading = false;

  // CONSTRUCTOR
  HistolungViewModel({required this.controller});

  // GETTER
  HistolungModel? get histolung => _histolungModel;
  Uint8List? get heatmap        => _heatmap;
  bool get isLoading            => _isLoading;

  // SETTER
  Future<void> analyzeImage(String imageName) async
  {
    print("VIEW MODEL : analyzeImage() called");
    // Set loading to true
    _setLoading(true);

    // Fetch the data from the controller
    print("VIEW MODEL : Fetching data from the controller");
    _histolungModel = await controller.analyzeImage(imageName); // Can take up to 3min30
    print("VIEW MODEL : Data fetched from the controller. Model updated");
    
    // Set loading to false
    _setLoading(false);
    
    // Notify the listeners that the state has changed
    print("VIEW MODEL : Notifying the listeners that the state has changed");
    notifyListeners(); // will call the builder method in the UI to rebuild the widget
    // this notification is called because the state of the model has changed, the model has been updated
    // the UI needs to be updated to reflect the new state of the model
  }

  Future<void> loadHeatmap() async
  {
    print("VIEW MODEL : loadHeatmap() called");
    // Set loading to true
    _setLoading(true);
    
    // Fetch the data from the controller
    print("VIEW MODEL : Fetching data from the controller");
    _heatmap = await controller.getHeatmap();

    // pass the heatmap to the model to display it in the UI. set the heatmap in the model and the prediction to null
    _histolungModel?.prediction = "null";
    _histolungModel?.heatmap = _heatmap!;

    print("VIEW MODEL : Data fetched from the controller. Heatmap updated");
    
    // Set loading to false
    _setLoading(false);

    // Notify the listeners that the state has changed
    print("VIEW MODEL : Notifying the listeners that the state has changed");
    notifyListeners();
  }

  void _setLoading(bool loading)
  {
    _isLoading = loading;
    print("VIEW MODEL : Loading set to $_isLoading");
    notifyListeners();
  }
}
