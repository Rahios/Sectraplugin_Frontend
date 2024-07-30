import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/utils/http/httpOverrides.dart';
import 'package:provider/provider.dart';

import 'histoLung/controllers/histolung_controller.dart';
import 'histoLung/viewModels/histolung_viewModel.dart';
import 'histoLung/views/histolung_page.dart';

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
        ChangeNotifierProvider(
          create: (_) => HistolungViewModel(
            controller: HistolungController(),
          ),
        ),
      ],

      // THEME - For consistent styling
      child: MaterialApp(
        title: 'SECTRA PACS - Plugin Viewer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
          useMaterial3: true,
        ),

        // PAGES - For navigation
        home: HistolungPage(),
      ),
    );
  }
}

