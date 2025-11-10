import 'package:wapfau/models/course.dart';

import '../models/user.dart';

class MockBackend {
  static late User user;

  // init
  static void init(User user) {
    MockBackend.user = user;
  }

  // funktionen für in-App schnittstelle
  static int getMaxCourses() {
    return getMaxCoursesByEmail(user.email)==null ? 0 : getMaxCoursesByEmail(user.email)!;
  }

  static List<Course> getAllCourses() {
    return getAllCoursesByEmail(user.email);
  }

  static bool alreadySelected() {
    return getSelectedCourses().length == getMaxCourses();
  }

  static List<Course> getSelectedCourses() {
    return getSelectedCoursesByEmail(user.email);
  }

  static (bool, List<Course>) saveCourses(List<Course> selectedCourses) {
    return MockBackend.updateCoursesByEmail(selectedCourses, user.email);
  }

  // api call funktionen (einzige zu bearbeiten, wenn Backend angebunden wird)
  static int? getMaxCoursesByEmail(String email){
    //hier backend aufruf mit User
    return 2;
  }

  static List<Course> getAllCoursesByEmail(String email) {
    // hier backend aufruf mit User
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
      Course(
        id: 'ing',
        title: 'Informationsverarbeitung',
        ects: 5,
        description: 'Automaten, Boolesche Algebra etc.',
        prof: 'Prof. Dr. Dorendorf',
        lvz: 2,
        availableSlots: 25,
        reservedSlots: 25,
      ),
      Course(
        id: 'algo',
        title: 'Algorithmen und Datenstrukturen',
        ects: 6,
        description: 'Komplexitätstheorie, Sortieralgorithmen, Graphen und Suchverfahren.',
        prof: 'Prof. Dr. Lena Koch',
        lvz: 3,
        availableSlots: 40,
        reservedSlots: 15,
      ),
      Course(
        id: 'netw',
        title: 'Rechnernetze und Kommunikationsprotokolle',
        ects: 5,
        description: 'Einführung in das OSI-Modell, TCP/IP-Protokolle, Routing und Switching.',
        prof: 'Dr. Hannes Berger',
        lvz: 2,
        availableSlots: 35,
        reservedSlots: 30,
      ),
      Course(
        id: 'mobd',
        title: 'Mobile App Entwicklung (Android/iOS)',
        ects: 6,
        description: 'Cross-Plattform Entwicklung mit modernen Frameworks, User Experience Design und Testing.',
        prof: 'Prof. Dr. Max Fischer',
        lvz: 3,
        availableSlots: 22,
        reservedSlots: 18,
      ),
      Course(
        id: 'its',
        title: 'Grundlagen der IT-Sicherheit',
        ects: 5,
        description: 'Kryptographie, Hashing-Verfahren, Angriffsszenarien und grundlegende Abwehrmaßnahmen.',
        prof: 'Prof. Dr. Silke Roth',
        lvz: 2,
        availableSlots: 30,
        reservedSlots: 5,
      )
    ];
  }

  static List<Course> getSelectedCoursesByEmail(String email) {
    //backend aufruf gibt leeres Array wenn leer, sonst array von Kursen
    return [
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
      )
    ];
  }

  // put / update http request via backend, to adjust the selectedCourses


  static (bool, List<Course>) updateCoursesByEmail(List<Course> selectedCourses, String email) {
    //should return true if it was successful, then give the selectedCourses based on a new request
    return (true, selectedCourses);
  }
}