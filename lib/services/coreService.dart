
import 'package:wapfau/services/courseService.dart';

import '../models/user.dart';

// Kern informationen und Schnittstellen der Anwendungen,
// welche keine instanzen benötigen

class CoreService {
  static bool hasBeenInitialized = false;

  static late User user;
  static late int maxCourses;
  static late CourseService courseService;

  static initCore(){
    user = User(nachname: "Schweiß", vorname: "Axel", matrNR: "G230025PI");
    courseService = CourseService();
    maxCourses = 2;
  }

  static User getUser() {
    if (!hasBeenInitialized) initCore();
    return user;
  }

  static int getMaxCourses() {
    if (!hasBeenInitialized) initCore();
    return maxCourses;
  }

  static CourseService getCourseService() {
    if (!hasBeenInitialized) initCore();
    return courseService;
  }
}

