import 'package:flutter/material.dart';
import 'package:wapfau/models/user.dart';
import 'package:wapfau/services/coreService.dart';

import '../models/course.dart';
import '../services/courseService.dart';
import '../widgets/card.dart';


class CoursePage extends StatefulWidget {
  const CoursePage({super.key, required this.title, required this.coreService});
  final String title;
  final CoreService coreService;
  @override
  State<CoursePage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursePage> {
  late int maxCourses;
  late User user;
  late CourseService courseService;
  late List<Course> courses;

  @override
  void initState() {
    super.initState();
    maxCourses = widget.coreService.getMaxCourses();
    user = widget.coreService.getUser();
    courseService = widget.coreService.getCourseService();

    // Load courses here
    courses = courseService.getAllCourses(); // <-- adjust to your API
  }

  void _toggleSelection(Course c) {
    setState(() {
      if (widget.coreService.selectedCourses.contains(c)) {
        widget.coreService.selectedCourses.remove(c);
      } else if (widget.coreService.selectedCourses.length < maxCourses) {
        widget.coreService.selectedCourses.add(c);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 60),
        itemCount: courses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final course = courses[i];
          final isSelected = widget.coreService.selectedCourses.contains(course);
          return CourseCard(
            course: course,
            isSelected: isSelected,
            onToggleSelect: () => _toggleSelection(course),
            canBeChosen: widget.coreService.selectedCourses.length < maxCourses
          );
        },
      ),
    );
  }
}
