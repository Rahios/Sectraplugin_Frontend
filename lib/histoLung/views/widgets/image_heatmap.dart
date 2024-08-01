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
                    minScale: 1,
                    maxScale: 10,
                    child:SizedBox( // Display the heatmap image with zoom functionality
                      width: double.infinity,   // Set the width to the maximum available width
                      height: double.infinity,  // Set the height to the maximum available height
                      child: Image.memory(
                          viewModel.histolung!.heatmap,
                          fit: BoxFit.contain,), // BoxFit.contain: The image is as large as possible while still containing the entire image within the parent widget
                    ),

                  )
                : const Center(child: Text('Aucune heatmap disponible')),
          );
  }
}
