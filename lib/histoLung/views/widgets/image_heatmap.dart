import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModels/histolung_viewModel.dart';

// IMAGE HEATMAP - Display the heatmap image with zoom functionality
class ImageHeatmap extends StatelessWidget {
  const ImageHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HistolungViewModel>(context);

    return viewModel.histolung == null
        ? const Center(child: Text('Aucune image disponible'))
        : Center(
            child: viewModel.histolung!.heatmap.isNotEmpty
                ? InteractiveViewer(
                    panEnabled: true,
                    boundaryMargin: const EdgeInsets.all(20),
                    minScale: 1,
                    maxScale: 10,
                    child: Image.memory(viewModel.histolung!.heatmap),
                  )
                : const Center(child: Text('Aucune heatmap disponible')),
          );
  }
}
