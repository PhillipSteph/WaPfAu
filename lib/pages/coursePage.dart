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
    courses = courseService.getAllCourses(); // ggf. an deine API anpassen
  }

  void _toggleSelection(Course c) {
    setState(() {
      if (widget.coreService.selectedCourses.contains(c)) {
        widget.coreService.selectedCourses.remove(c);
      } else if (widget.coreService.selectedCourses.length < maxCourses && (c.availableSlots - c.reservedSlots) > 0) {
        widget.coreService.selectedCourses.add(c);
      }
    });
  }

  // null-sichere Suche über Titel, Prof und Beschreibung
  String _lc(String? s) => (s ?? '').toLowerCase();
  bool _matchesCourse(Course c, String q) {
    final qq = q.trim().toLowerCase();
    return _lc(c.title).contains(qq) ||
        _lc(c.prof).contains(qq) ||
        _lc(c.description).contains(qq);
  }

  List<Course> get _filteredCourses {
    if (_query.isEmpty) return courses;
    return courses.where((c) => _matchesCourse(c, _query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),

          // SearchBar ohne Inline-Suggestions
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
              itemCount: _filteredCourses.length + 1, // +1 für die SearchBar
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return CourseSearchBar(
                    onQueryChanged: (q) => setState(() => _query = q),
                    initialQuery: _query,
                    hintText: 'Module, Dozent:in oder Beschreibung',
                    padding: EdgeInsets.all(0)
                  );
                }

                final course = _filteredCourses[i - 1]; // Index verschieben
                final isSelected = widget.coreService.selectedCourses.contains(course);

                return CourseCard(
                  course: course,
                  isSelected: isSelected,
                  onToggleSelect: () => _toggleSelection(course),
                  canBeChosen: widget.coreService.selectedCourses.length < maxCourses,
                );
              },
            ),
          )

        ],
      ),
    );
  }
}
