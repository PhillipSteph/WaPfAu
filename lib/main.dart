import 'package:flutter/material.dart';
import 'package:wapfau/pages/ErrorScreen.dart';
import 'package:wapfau/pages/confirmationPage.dart';
import 'package:wapfau/pages/coursePage.dart';
import 'package:wapfau/services/coreService.dart';
import 'package:wapfau/services/courseService.dart';
import 'package:wapfau/widgets/card.dart';

import 'api/mockBackend.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wapfau',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      ),
      home: const MyHomePage(title: 'Wahlpflicht Auswahl'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CoreService coreService = CoreService();

  @override
  void initState() {
    super.initState();

    // Check for navigation only if initialization was successful.
    if (coreService.getInitializationError() == null) {
      // Schedule the navigation to run *after* the first frame is rendered.
      // This ensures we have a valid BuildContext for Navigator.of(context).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAndNavigate();
      });
    }
  }

  void _checkAndNavigate() {
    // If the user has already selected courses, push the ConfirmationPage on top.
    if (MockBackend.alreadySelected()) {
      Navigator.of(context).push(
        MaterialPageRoute(
          // Ensure your ConfirmationPage can handle being pushed onto the stack.
          builder: (context) => ConfirmationPage(coreService: coreService),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Check for initialization error first.
    if (coreService.getInitializationError() != null) {
      return ErrorScreen(message: coreService.getInitializationError()!);
    }

    // 2. If no error, always show the CoursePage as the base screen.
    return Scaffold(
      body: CoursePage(title: 'Kurse', coreService: coreService),
    );
  }
}