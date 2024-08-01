import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModels/histolung_viewModel.dart';

// VIEW - Histolung Page UI
// ROLE : User actions are captured in the UI and passed to the ViewModel
// Implements the ViewModel listener to update the UI based on ViewModel changes
// Is a stateless because the state is managed by the ViewModel and not the UI
class HistolungPage extends StatelessWidget {
  // Constructor with key - To identify the widget uniquely in the widget tree
  const HistolungPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection - LISTENER of ViewModel changes
    final viewModel = Provider.of<HistolungViewModel>(context);

    // Page UI
    return Scaffold(
      // AppBar - Page title
      appBar: AppBar(title: const Text('Histolung Analyses')),

      // Body - Page content
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Top row with two blocks
          GestureDetector(
            onVerticalDragUpdate: (DragUpdateDetails details) {
              viewModel.updateTopPanelHeight(details.delta.dy);
            },
            child: Container(
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
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Images disponibles',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () => viewModel.scanImagesFolder(),
                            tooltip: 'Rafrachir la liste des images disponibles',
                          ),
                          Expanded(
                            child: viewModel.availableImages.isNotEmpty
                                ? ListView.builder(
                              itemCount: viewModel.availableImages.length,
                              itemBuilder: (context, index) {
                                final imageName = viewModel.availableImages[index];
                                return ListTile(
                                  title: Text(imageName),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.analytics),
                                    onPressed: () => viewModel.analyzeImage(imageName),
                                  ),
                                );
                              },
                            )
                                : const Center(child: Text('Aucune image disponible pour l\'analyse')),
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
                                    .map((entry) => Text('${entry.key}: ${entry.value}'))
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
          ),
          const Divider(height: 1),

          // IMAGE HEATMAP - Display the heatmap image
          Expanded(
            child: viewModel.histolung == null
                ? const Center(child: Text('Aucune image disponible'))
                : Center(
              child: viewModel.histolung!.heatmap.isNotEmpty
                  ? Image.memory(viewModel.histolung!.heatmap)
                  : const Center(child: Text('Aucune heatmap disponible')),
            ),
          ),
        ],
      ),

      // Floating Action Button - User actions bottom right
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Wrap(
            direction: Axis.vertical,
            spacing: 10,
            children: [
              FloatingActionButton(
                onPressed: () => viewModel.analyzeImage('TCGA-18-3417-01Z-00-DX1.tif'),
                tooltip: 'Analyser Image : TCGA-18-3417-01Z-00-DX1.tif',
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
      ),
    );
  }
}
