import 'package:flutter/material.dart';

import '../../models/course.dart';
import '../spacer.dart';
import 'confirmationCourseCard.dart';

class ConfirmationCourses extends StatefulWidget {
  final List<Course> selectedCourses;

  const ConfirmationCourses({super.key, required this.selectedCourses});
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
                            color: Color(0xFF111122),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.1),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Text("${widget.selectedCourses.length} Module", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
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
                        child: Text("$totalECTS ECTS-Punkte", style: TextStyle(fontSize: 18)),
                      )
                    ],
                  ),
                  SpacerWidget(),
                  ...widget.selectedCourses.map((course) => Padding(
                    padding: const EdgeInsets.only(bottom: 12), // spacing between cards
                    child: ConfirmationCourseCard(course: course),
                  )),
                ],

              )
          )
      );
  }
}
