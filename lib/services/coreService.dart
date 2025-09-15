import 'package:wapfau/services/courseService.dart';

import '../models/course.dart';
import '../models/user.dart';

// Kerninformationen und Schnittstellen der Anwendungen,
// jetzt als normale Instanz, nicht mehr statisch
class CoreService {
  bool hasBeenInitialized = false;

  late User user;
  late int maxCourses;
  late CourseService courseService;
  List<Course> selectedCourses = [];

  CoreService() {
    _initCore();
  }

  void _initCore() {
    if (hasBeenInitialized) return;

    user = User(
      nachname: "Schweiß",
      vorname: "Axel",
      matrNR: "G230025PI",
    );
    courseService = CourseService();
    maxCourses = 2;

    hasBeenInitialized = true;
  }

  User getUser() {
    if (!hasBeenInitialized) _initCore();
    return user;
  }

  int getMaxCourses() {
    if (!hasBeenInitialized) _initCore();
    return maxCourses;
  }

  CourseService getCourseService() {
    if (!hasBeenInitialized) _initCore();
    return courseService;
  }
}
