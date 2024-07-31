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
  // Controller to be used by the view model
  final HistolungController controller;

  // Properties of the model to be used by the viewModel
  HistolungModel? _histolungModel;
  bool            _isLoading = false;
  Map<String, String>? _predictionDetails;

  // CONSTRUCTOR
  HistolungViewModel({required this.controller});

  // GETTER from the ChangeNotifier class that we are extending
  // Properties to be used by the view Ui to display the data of the model
  HistolungModel? get histolung => _histolungModel;
  bool get isLoading            => _isLoading;
  Map<String, String>? get predictionDetails => _predictionDetails;

  // SETTER to update the state of the model and notify the listeners. Done with the ChangeNotifier class
  Future<void> analyzeImage(String imageName) async
  {
    print("VIEW MODEL : analyzeImage() called");
    // Set loading to true
    setLoading(true);

    try
    {
      // Fetch the data from the controller
      print("VIEW MODEL : Fetching data from the controller");
      _histolungModel = await controller.analyzeImage(imageName); // Can take up to 3min30
      extractPredictionDetails();
      print("VIEW MODEL : Data fetched from the controller. Model updated");
    }
    catch(e)
    {
      print("VIEW MODEL : Error in fetching data from the controller");
      print('Error: $e');
    }
    finally
    {
      // Set loading to false
      setLoading(false);

      // Notify the listeners that the state has changed
      print("VIEW MODEL : Notifying the listeners that the state has changed");
      notifyListeners(); // will call the builder method in the UI to rebuild the widget
      // this notification is called because the state of the model has changed, the model has been updated
      // the UI needs to be updated to reflect the new state of the model
    }

  }


  Future<void> loadHeatmap() async
  {
    print("VIEW MODEL : loadHeatmap() called");
    // Set loading to true
    setLoading(true);

    try
    {
      // Fetch the data from the controller
      print("VIEW MODEL : Fetching data from the controller");
      _histolungModel = await controller.getHeatmap();

      print("VIEW MODEL : Data fetched from the controller. Heatmap updated");
    }
    catch(e)
    {
      print("VIEW MODEL : Error in fetching data from the controller");
    }
    finally
    {
      // Set loading to false
      setLoading(false);

      // Notify the listeners that the state has changed
      print("VIEW MODEL : Notifying the listeners that the state has changed");
      notifyListeners();
    }
  }

  // Method to set the loading state of the model and notify the listeners
  void setLoading(bool loading)
  {
    _isLoading = loading;
    print("VIEW MODEL : Loading set to $_isLoading");
    notifyListeners();
  }

  // Method to print the data of the model to the console for debugging
  printModelData() {
    // Print the data of the model to the console
    print("VIEW MODEL : Printing the data of the model");
    print("VIEW MODEL : Histolung Model : ${_histolungModel.toString()}");
    print("VIEW MODEL : Heatmap : ${_histolungModel?.heatmap.toString()}");
    print("VIEW MODEL : Prediction : ${_histolungModel?.prediction.toString()}");
    print("VIEW MODEL : Data printed");
  }

  /**
   * Extracts the prediction details from the prediction string and stores them in a map.
   * Allowing the UI to display the prediction details in a table.
   */
  void extractPredictionDetails()
  {
    // If the prediction string is not empty and contains a comma separated list of values and headers
    if (_histolungModel?.prediction.isNotEmpty ?? false)
    {
      // Split the prediction string into lines and extract the headers and values
      final lines = _histolungModel!.prediction.split('\n');

      // If there are more than one line in the prediction string
      if (lines.length > 1)
      {
        final headers = ['index', ...lines[0].split(',').sublist(1)]; // Add 'index' to the headers and split the first line into headers
        final values = lines[1].split(',');   // Split the second line into values

        print("VIEW MODEL : Headers : $headers AND Length : ${headers.length}");
        print("VIEW MODEL : Values : $values AND Length : ${values.length}");

        if (headers.length == values.length)
        {
          _predictionDetails = Map.fromIterables(headers, values);
        }
      }
    }
  }
}
