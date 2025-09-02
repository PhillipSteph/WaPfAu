// course_service.dart
import '../models/course.dart';

class CourseService {
  // In a real app, this might fetch from a backend / API.
  // For now, it just returns a hardcoded list.
  List<Course> getAllCourses() {
    return const [
      Course(
        id: 'ml',
        title: 'Machine Learning Grundlagen',
        ects: 6,
        description: 'Einführung in maschinelles Lernen mit praktischen Übungen',
        prof: 'Prof. Dr. Anna Schmidt',
        lvz: 2,
        availableSlots: 30,
        reservedSlots: 27,
      ),
      Course(
        id: 'db',
        title: 'Datenbanken',
        ects: 5,
        description: 'Relationale Modelle, SQL, Normalisierung',
        prof: 'Dr. Müller',
        lvz: 2,
        availableSlots: 25,
        reservedSlots: 25,
      ),
      Course(
        id: 'se',
        title: 'Software Engineering',
        ects: 6,
        description: 'Grundlagen von Softwarearchitektur und Entwicklungsmethoden',
        prof: 'Prof. Dr. Weber',
        lvz: 3,
        availableSlots: 20,
        reservedSlots: 10,
      ),
    ];
  }
}
