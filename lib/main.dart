import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/utils/http/httpOverrides.dart';
import 'package:provider/provider.dart';

import 'histoLung/controllers/histolung_controller.dart';
import 'histoLung/viewModels/histolung_viewModel.dart';
import 'histoLung/views/histolung_page.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF667FC3), // Soft blue for primary color
            onPrimary: Colors.white, // Text color on primary color
            secondary: Color(0xFF56A15B), // Soft green for secondary color
            onSecondary: Colors.white, // Light grey for background
            surface: Colors.white, // Black text on background
            onSurface: Colors.black, // Black text on surface
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Light grey background for the app
          appBarTheme: const AppBarTheme(
            color: Color(0xFF667FC3), // Soft blue for AppBar
            iconTheme: IconThemeData(color: Colors.white), // White icons on AppBar
            titleTextStyle: TextStyle(
              color: Colors.white, // White text on AppBar
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF56A15B), // Soft green for FloatingActionButton
            foregroundColor: Colors.white, // White icons on FloatingActionButton
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.black), // Black text for body text
            titleLarge: TextStyle(color: Colors.black), // Black text for headlines
          ),
          cardTheme: const CardTheme(
            color: Colors.white, // White background for cards
            shadowColor: Colors.grey, // Grey shadow for cards
            elevation: 4,
            margin: EdgeInsets.all(8),
          ),
        ),

        /* OLD THEME - BUT EASIER TO USE
          theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
          useMaterial3: true,
        ),*/

      ),
    );
  }
}

