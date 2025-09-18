import 'package:flutter/material.dart';
import 'package:wapfau/assets/colors.dart';
import 'package:wapfau/services/coreService.dart';

import '../../models/course.dart';
import '../../pages/coursePage.dart';
import '../spacer.dart';
import 'confirmationCourseCard.dart';

class ConfirmationCourses extends StatefulWidget {
  final List<Course> selectedCourses;
  final CoreService coreService;
  const ConfirmationCourses({super.key, required this.selectedCourses, required this.coreService});
  @override
  State<ConfirmationCourses> createState() => _ConfirmationCoursesState();
}

class _ConfirmationCoursesState extends State<ConfirmationCourses> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int totalECTS = widget.selectedCourses.fold(
      0, // initial value
          (sum, course) => sum + course.ects,
    );
    return
      ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity),
          child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black.withOpacity(0.1),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ihre gewählten Module",
                    style: TextStyle(fontSize: 18)
                  ),
                  SpacerWidget(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: AppColors.courseCounterBg,
                            border: Border.all(
                              color: Colors.black.withOpacity(0.1),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Text("${widget.selectedCourses.length} Module", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black.withOpacity(0.1),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Text("$totalECTS ECTS-Punkte", style: TextStyle(fontSize: 14)),
                      )
                    ],
                  ),
                  SpacerWidget(),
                  ...widget.selectedCourses.map((course) => Padding(
                    padding: const EdgeInsets.only(bottom: 12), // spacing between cards
                    child: ConfirmationCourseCard(course: course),
                  )),
                  Divider(),
                  SpacerWidget(height: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoursePage(title: 'Kurse', coreService: widget.coreService),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black.withOpacity(0.1)), // optional border
                        color: Colors.transparent, // optional background
                      ),
                      child: const Center(
                        child: Text(
                          'Auswahl bearbeiten',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
          )
      );
  }
}
