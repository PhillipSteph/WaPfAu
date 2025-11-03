// course_service.dart
import '../api/mockBackend.dart';
import '../models/course.dart';

class CourseService {
  // In a real app, this might fetch from a backend / API.
  // For now, it just returns a hardcoded list.
  List<Course> getAllCourses() {
    return MockBackend.getAllCourses();
  }
}
