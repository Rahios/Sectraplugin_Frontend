import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModels/histolung_viewModel.dart';

// VIEW - Histolung Page UI
// ROLE : User actions are captured in the UI and passed to the ViewModel
// Implements the ViewModel listener to update the UI based on ViewModel changes
//
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
                ? const Center(child: Text('No data'))
                : Column(
              children: [
                Text('Prediction: ${viewModel.histolung!.prediction}'),
                viewModel.heatmap != null
                    ? Center(
                  child: Image.memory(viewModel.heatmap!),
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
          FloatingActionButton(
            onPressed: () => viewModel.analyzeImage('sample_image_name'),
            tooltip: 'Analyze Image',
            child: const Icon(Icons.analytics),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => viewModel.loadHeatmap(),
            tooltip: 'Load Heatmap',
            child: const Icon(Icons.image),
          ),
        ],
      ),
    );
  }
}
