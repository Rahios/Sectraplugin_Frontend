import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModels/histolung_viewModel.dart';
import '../views/widgets/floating_action_buttons.dart';
import '../views/widgets/image_heatmap.dart';
import '../views/widgets/top_panel.dart';

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
          : const Column(
              children: [

                // Top row with two blocks
                TopPanel(),
                Divider(height: 1),

                // IMAGE HEATMAP - Display the heatmap image
                Expanded(child: ImageHeatmap()),
              ],
            ),

      // Floating Action Button - User actions bottom right
      floatingActionButton: const FloatingActionButtons(),
    );
  }
}
