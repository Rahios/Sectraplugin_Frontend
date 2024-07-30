import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModels/histolung_viewModel.dart';

class HistolungPage extends StatelessWidget {
  const HistolungPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    // Dependency Injection
    final viewModel = Provider.of<HistolungViewModel>(context);

    // Page UI
    return Scaffold(
      appBar: AppBar(title: const Text('Histolung Analysis')),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
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
