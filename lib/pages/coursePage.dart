import 'package:flutter/material.dart';
import 'package:wapfau/models/user.dart';
import 'package:wapfau/services/coreService.dart';

import '../models/course.dart';
import '../services/courseService.dart';
import '../widgets/card.dart';
import '../widgets/searchbar.dart';

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
  String _query = '';

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

  List<Course> get _filteredCourses {
    if (_query.isEmpty) return courses;
    final q = _query.toLowerCase();
    return courses.where((c) => c.title.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),

          // SearchBar
          CourseSearchBar(
            onQueryChanged: (q) => setState(() => _query = q),
            initialQuery: _query,
            hintText: 'Module durchsuchen ...',
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
              itemCount: _filteredCourses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final course = _filteredCourses[i];
                final isSelected = widget.coreService.selectedCourses.contains(course);
                return CourseCard(
                  course: course,
                  isSelected: isSelected,
                  onToggleSelect: () => _toggleSelection(course),
                  canBeChosen: widget.coreService.selectedCourses.length < maxCourses,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
