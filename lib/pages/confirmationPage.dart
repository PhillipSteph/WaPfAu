import 'package:flutter/material.dart';
import 'package:wapfau/widgets/confirmation/confirmationBanner.dart';

import '../models/course.dart';
import '../services/coreService.dart';
import '../widgets/confirmation/confirmationCourses.dart';
import '../widgets/spacer.dart';

class ConfirmationPage extends StatefulWidget {
  final CoreService coreService;
  const ConfirmationPage({super.key, required this.coreService});
  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {

  @override
  void initState() {
    // debug information
    widget.coreService.selectedCourses = [
      Course(
        id: 'ml',
        title: 'Machine Learning Grundlagen',
        ects: 6,
        description: 'Einführung in maschinelles Lernen mit praktischen Übungen',
        prof: 'Prof. Dr. Anna Schmidt',
        lvz: 2,
        availableSlots: 30,
        reservedSlots: 27,
      ),
      Course(
        id: 'db',
        title: 'Datenbanken',
        ects: 5,
        description: 'Relationale Modelle, SQL, Normalisierung',
        prof: 'Dr. Müller',
        lvz: 2,
        availableSlots: 25,
        reservedSlots: 25,
      )
    ];
    widget.coreService.initCore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 60),
        child: Column(
          children: [
            ConfirmationBanner(),
            SpacerWidget(height: 24),
            ConfirmationCourses(selectedCourses: widget.coreService.selectedCourses, coreService: widget.coreService),
          ],
        )
      ),
    );
  }
}
