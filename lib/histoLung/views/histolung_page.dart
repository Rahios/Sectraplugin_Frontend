// lib/views/histolung_page.dart

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModels/histolung_viewModel.dart';

class HistolungPage extends StatelessWidget
{
  const HistolungPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    // Dependency Injection
    final viewModel = Provider.of<HistolungViewModel>(context);

    // Page UI
    return Scaffold(
      appBar: AppBar(title: const Text('Histolung Analysis')),
      body: Column(
        children: [
          viewModel.histolung == null
              ? const Center(child: Text('No data'))
              : Column(
            children: [
              Text('Prediction: ${viewModel.histolung!.prediction}'),
              viewModel.heatmap != null
                  ? Image.memory(viewModel.heatmap!)
                  : const Text('No heatmap available'),
            ],
          ),
        ],
      ),

      // Button to analyze the image and load the heatmap
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
