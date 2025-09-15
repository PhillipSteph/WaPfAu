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
 // eigentlich müsste man hier irgendwie auf die coreService instanz zugreifen können
  int maxCourses = CoreService.getMaxCourses();
  User user = CoreService.getUser();
  final courseService = CoreService.getCourseService();

  late final List<Course> courses;

  @override
  void initState() {
    super.initState();
    courses = courseService.getAllCourses();
  }

  void _toggleSelection(Course c) {
    setState(() {
      if (CoreService.selectedCourses.contains(c)) {
        CoreService.selectedCourses.remove(c);
      } else if (CoreService.selectedCourses.length < maxCourses) {
        CoreService.selectedCourses.add(c);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kurswahl')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final course = courses[i];
          final isSelected = CoreService.selectedCourses.contains(course);
          return CourseCard(
            course: course,
            isSelected: isSelected,
            onToggleSelect: () => _toggleSelection(course),
            canBeChosen: CoreService.selectedCourses.length < maxCourses
          );
        },
      ),
    );
  }
}
