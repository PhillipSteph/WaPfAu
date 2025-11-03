import 'package:flutter/material.dart';
import 'package:wapfau/widgets/confirmation/confirmationBanner.dart';

import '../assets/colors.dart';
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
    widget.coreService.initCore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 24),
        child: Column(
          children: [
            ConfirmationBanner(),
            SpacerWidget(height: 24),
            ConfirmationCourses(selectedCourses: widget.coreService.selectedCourses, coreService: widget.coreService),
            SpacerWidget(height: 12),
            GestureDetector(
              onTap: () {
                Navigator.pop(
                  context
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.black.withOpacity(0.1)), // optional border
                  color: Colors.transparent, // optional background
                ),
                child: const Center(
                  child: Text(
                    'Auswahl bearbeiten',
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}
