import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModels/histolung_viewModel.dart';

// Top row with two blocks
class TopPanel extends StatelessWidget {
  const TopPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HistolungViewModel>(context);

    // 2 gestures detectors to handle the vertical and horizontal drag events on the top panel
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        viewModel.updateTopPanelHeight(details.delta.dy);
      },
      child: SizedBox(
        height: viewModel.topPanelHeight,
        child: Row(
          children: [
            // AVAILABLE IMAGES - Display the available images (Left)
            GestureDetector(
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                viewModel.updatePanelWidth(details.delta.dx);
              },
              child: Container(
                width: viewModel.panelWidth,
                color: Colors.grey[200],
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Images disponibles',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () => viewModel.scanImagesFolder(),
                            tooltip:
                                'Rafraîchir la liste des images disponibles',
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: viewModel.isImagesFolderLoading
                          ? const Center(child: CircularProgressIndicator())
                          : viewModel.availableImages.isNotEmpty
                              ? ListView.builder(
                                  itemCount: viewModel.availableImages.length,
                                  itemBuilder: (context, index) {
                                    final imageName =
                                        viewModel.availableImages[index];
                                    return ListTile(
                                      title: Text(imageName),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.analytics),
                                        onPressed: () =>
                                            viewModel.analyzeImage(imageName),
                                        tooltip:
                                            'Lancer l\'analyse de l\'image $imageName',
                                      ),
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text(
                                      'Aucune image disponible pour l\'analyse')),
                    ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(width: 1),

            // PREDICTION DETAILS - Display the prediction details (Right)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Prediction :',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (viewModel.predictionDetails != null &&
                        viewModel.predictionDetails!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: viewModel.predictionDetails!.entries
                              .skip(1) // Skip the first entry (index)
                              .map((entry) =>
                                  Text('${entry.key}: ${entry.value}'))
                              .toList(),
                        ),
                      )
                    else
                      const Center(child: Text('Aucune prédiction disponible')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
