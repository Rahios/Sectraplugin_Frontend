import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/utils/http/httpOverrides.dart';
import 'package:provider/provider.dart';

import 'histoLung/controllers/histolung_controller.dart';
import 'histoLung/viewModels/histolung_viewModel.dart';
import 'histoLung/views/histolung_page.dart';

// How to remove the A4 format for my code ? there is a vertical line that I can't remove and my code wraps around


void main() {
  // ToDo : remove this HTTP override for production build. Use Let's Encrypt SSL in the backend & Frontend.
  HttpOverrides.global = MyHttpOverrides(); // For SSL certificate (self signed), for testing purposes only
  runApp(const MyApp());
}


class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)
  {
    return MultiProvider(

      // PROVIDERS - For state management & dependency injection
      providers: [
        // Provider for ViewModel & Controller
        ChangeNotifierProvider(                 // Notifier listens to changes in the ViewModel and updates the UI accordingly
          create: (_) => HistolungViewModel(    // Creates a new instance of the ViewModel. it's a singleton injected into the Provider. (Dependency Injection)
            controller: HistolungController(),  // Injects the Controller into the ViewModel. (Dependency Injection) So that the ViewModel can call the Controller's methods.
          ),
        ),
      ],

      // MaterialApp - The main widget of the app
      child: MaterialApp(
        title: 'SECTRA PACS - Plugin Viewer',

        // PAGES - For navigation
        home: const HistolungPage(),

        // THEME - For styling
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
          useMaterial3: true,
        ),
      ),
    );
  }
}

