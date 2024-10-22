import 'package:flutter/foundation.dart';
import '../models/histolung_model.dart';
import '../controllers/histolung_controller.dart';

/// VIEW MODEL
/// This class is responsible for managing the state of the Histolung model.
/// Extends ChangeNotifier to notify the listeners when the state changes.
/// It interacts with the HistolungController to fetch the data and update the state.
/// It notifies the listeners when the state changes.
/// ROLE : - State Management of the Histolung model
///        - Fetch data from the controller
///        - Update the state of the model via the controller
///        - Notify the listeners in the UI when the state changes
/// Implement the business logic of the application
class HistolungViewModel extends ChangeNotifier
{
  // Controller to be used by the view model
  final HistolungController controller;

  // Properties of the model to be used by the viewModel
  HistolungModel? _histolungModel;
  bool            _isLoading              = false;
  bool            _isHeatmapLoading       = false;
  bool            _isImagesFolderLoading  = false;
  Map<String, String>? _predictionDetails;
  double _panelWidth = 500; // Initial width of the resizable panel
  double _topPanelHeight = 200.0; // Initial height of the top panel
  List<String> _availableImages = [];


  // CONSTRUCTOR
  HistolungViewModel({required this.controller})
  {
    // Automatically scan the images folder on initialization
    scanImagesFolder();
  }

  // GETTER from the ChangeNotifier class that we are extending
  // Properties to be used by the view Ui to display the data of the model
  // On the left (property used in the UI) and on the right (property of the view model)
  HistolungModel? get histolung  => _histolungModel;
  bool get isLoading             => _isLoading;
  bool get isHeatmapLoading      => _isHeatmapLoading;
  bool get isImagesFolderLoading => _isImagesFolderLoading;
  Map<String, String>? get predictionDetails => _predictionDetails;
  double get panelWidth             => _panelWidth;
  double get topPanelHeight         => _topPanelHeight;
  List<String> get availableImages  => _availableImages;

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

  Future<void> getLastAnalysis() async
  {
    print("VIEW MODEL : getLastAnalysis() called");
    setLoading(true);

    try
    {
      // Fetch the data from the controller
      print("VIEW MODEL : Fetching data from the controller");
      _histolungModel = await controller.getLastAnalysis();
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
      setLoading(false);

      // Notify the listeners that the state has changed
      print("VIEW MODEL : Notifying the listeners that the state has changed");
      notifyListeners(); // will call the builder method in the UI to rebuild the widget
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

  // Method to scan the images folder and get the list of available images
  Future<void> scanImagesFolder() async
  {
    print("VIEW MODEL : scanImagesFolder() called");
    setImagesFolderLoading(true);
    
    try
    {
      _availableImages = await controller.scanImagesFolder();
      print("VIEW MODEL : Images scanned from the folder");
      print("VIEW MODEL : Available Images : $_availableImages");
    }
    catch(e)
    {
      print("VIEW MODEL : Error in fetching data from the controller");
    }
    finally
    {
      setImagesFolderLoading(false);
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

  void setHeatmapLoading(bool loading) {
    _isHeatmapLoading = loading;
    notifyListeners();
  }

  void setImagesFolderLoading(bool loading) {
    _isImagesFolderLoading = loading;
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

  // Method to update the width of the resizable panel
  void updatePanelWidth(double delta) {
    _panelWidth += delta;
    notifyListeners();
  }

  // Method to update the height of the top panel
  void updateTopPanelHeight(double delta) {
    _topPanelHeight += delta;
    notifyListeners();
  }

}
