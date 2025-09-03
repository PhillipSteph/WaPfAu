import 'package:flutter/material.dart';

import '../models/course.dart';
import '../services/courseService.dart';
import '../widgets/card.dart';


class MyCoursePage extends StatefulWidget {
  const MyCoursePage({super.key, required this.title});
  final String title;

  @override
  State<MyCoursePage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursePage> {
  int maxCourses = 2;

  final courseService = CourseService();
  late final List<Course> courses;

  final List<Course> selectedCourses = [];

  @override
  void initState() {
    super.initState();
    courses = courseService.getAllCourses();
  }

  void _toggleSelection(Course c) {
    setState(() {
      if (selectedCourses.contains(c)) {
        selectedCourses.remove(c);
      } else if (selectedCourses.length < maxCourses) {
        selectedCourses.add(c);
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
          final isSelected = selectedCourses.contains(course);
          return CourseCard(
            course: course,
            isSelected: isSelected,
            onToggleSelect: () => _toggleSelection(course),
            canBeChosen: selectedCourses.length < maxCourses
          );
        },
      ),
    );
  }
}
