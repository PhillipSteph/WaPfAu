import 'package:wapfau/services/courseService.dart';

import '../models/course.dart';
import '../models/user.dart';

// Kerninformationen und Schnittstellen der Anwendungen,
// jetzt als normale Instanz, nicht mehr statisch
class CoreService {
  bool hasBeenInitialized = false;

  late bool selectionDone;
  late User user;
  late int maxCourses;
  late CourseService courseService;
  List<Course> selectedCourses = [];

  CoreService() {
    initCore();
  }

  void initCore() {
    // backendaufrufe in Zukunft
    if (hasBeenInitialized) return;

    user = User(
      nachname: "Schweiß",
      vorname: "Axel",
      matrNR: "G230025PI",
    );
    courseService = CourseService();
    maxCourses = 2;

    hasBeenInitialized = true;

    selectionDone = isSelectionDoneByUser();
  }

  User getUser() {
    if (!hasBeenInitialized) initCore();
    return user;
  }

  int getMaxCourses() {
    if (!hasBeenInitialized) initCore();
    return maxCourses;
  }

  CourseService getCourseService() {
    if (!hasBeenInitialized) initCore();
    return courseService;
  }

  bool isSelectionDoneByUser() {
    if (!hasBeenInitialized) initCore();
    //backend aufruf, ob bereits ausgewählt
    return selectedCourses.length >= maxCourses;
  }
}
