import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModels/histolung_viewModel.dart';

// Floating Action Button - User actions bottom right
class FloatingActionButtons extends StatelessWidget {
  const FloatingActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HistolungViewModel>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Wrap(
          direction: Axis.vertical,
          spacing: 10,
          children: [
            FloatingActionButton(
              onPressed: () => viewModel.analyzeImage('TCGA-85-6798-01Z-00-DX1.tif'),
              tooltip: 'Analyser Image : TCGA-85-6798-01Z-00-DX1.tif',
              child: const Icon(Icons.analytics),
            ),
            FloatingActionButton(
              onPressed: () => viewModel.getLastAnalysis(),
              tooltip: 'Afficher la dernière analyse',
              child: const Icon(Icons.image),
            ),
            FloatingActionButton(
              onPressed: () => viewModel.printModelData(),
              tooltip: 'Afficher les données du modèle',
              child: const Icon(Icons.data_object),
            ),
          ],
        ),
      ],
    );
  }
}
