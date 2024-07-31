import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModels/histolung_viewModel.dart';

// VIEW - Histolung Page UI
// ROLE : User actions are captured in the UI and passed to the ViewModel
// Implements the ViewModel listener to update the UI based on ViewModel changes
// Is a stateless because the state is managed by the ViewModel and not the UI
class HistolungPage extends StatelessWidget
{
  // Constructor with key - To identify the widget uniquely in the widget tree
  const HistolungPage({super.key});

  // Build - UI
  @override
  Widget build(BuildContext context)
  {
    // Dependency Injection - LISTENER of ViewModel changes
    final viewModel = Provider.of<HistolungViewModel>(context);

    // Page UI
    return Scaffold(
      // AppBar - Page title
      appBar: AppBar(title: const Text('Histolung Analysis')),

      // Body - Page content
      // If loading, show progress indicator
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            // Image - Display the image
            viewModel.histolung == null
                ? const Center(child: Text('No data model available'))
                : Column(

              // UI : Column of Prediction Details and Heatmap vertically aligned
              children: [
                // Prediction Details
                const Text('Prediction Details:'),
                if (viewModel.predictionDetails != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      // UI : List of Prediction Details horizontally aligned with key-value pairs
                      // Each entry is a row with key and value displayed
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: viewModel.predictionDetails!.entries
                          .map((entry) => Text('${entry.key}: ${entry.value}'))
                          .toList(),
                    ),
                  ),

                // Heatmap
                viewModel.histolung!.heatmap.isNotEmpty
                    ? Center(
                  child: Image.memory(viewModel.histolung!.heatmap),
                )
                    : const Center(child: Text('No heatmap available')),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //todo: DONNER UN NOM MANUELLEMENT DE L'IMAGE A ANALYSER
          FloatingActionButton(
            onPressed: () => viewModel.analyzeImage('TCGA-18-3417-01Z-00-DX1.tif'),
            tooltip: 'Analyze Image',
            child: const Icon(Icons.analytics),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => viewModel.loadHeatmap(),
            tooltip: 'Load Heatmap',
            child: const Icon(Icons.image),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => viewModel.printModelData(),
            tooltip: 'Print in console the model data',
            child: const Icon(Icons.ac_unit),
          ),
        ],
      ),
    );
  }
}
