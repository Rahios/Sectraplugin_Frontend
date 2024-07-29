// lib/views/histolung_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModels/histolung_viewModel.dart';

class HistolungPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    final viewModel = Provider.of<HistolungViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Histolung Analysis')),
      body: viewModel.histolung == null
          ? Center(child: Text('No data'))
          : Column(
        children: [
          Text('Prediction: ${viewModel.histolung!.prediction}'),
          Image.memory(viewModel.histolung!.heatmap.codeUnits), // Assuming the heatmap is a base64 string. NO IT IS NOT. IT IS A PNG IMAGE FILE
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.analyzeImage('sample_image_name'),
        child: Icon(Icons.refresh),
      ),
    );
  }
}
