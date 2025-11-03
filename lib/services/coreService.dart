import 'package:wapfau/services/courseService.dart';
import '../models/course.dart';
import '../models/user.dart';
import '../api/mockBackend.dart';
// --- MOCK CLASS DEFINITIONS (Assume these are in your actual project files) ---
// -----------------------------------------------------------------------------

// Kerninformationen und Schnittstellen der Anwendungen,
// jetzt als normale Instanz, nicht mehr statisch
class CoreService {
  bool hasBeenInitialized = false;
  String? _initializationError; // New field to hold error message

  late bool selectionDone;
  late User user;
  late int maxCourses;
  late CourseService courseService;
  List<Course> selectedCourses = [];

  CoreService() {
    initCore();
  }

  void initCore() {
    // Stop if already initialized or if a previous error occurred.
    if (hasBeenInitialized || _initializationError != null) return;

    final String? name = Uri.base.queryParameters['name'];
    final String? email = Uri.base.queryParameters['email'];

    // 1. VALIDATION CHECK: Stop and set error if parameters are missing or empty
    if (name == null || email == null || name.isEmpty || email.isEmpty) {
      _initializationError = "URL Parameter für 'name' und 'email' nicht gefunden. Gehe Sicher, dass diese Seite konform aufgerufen wurde und prüfe, ob die URL konform ist (https://url.de?name=Axel&email=axel@mail.de). ";
      // We return here, preventing hasBeenInitialized from being set to true.
      return;
    }

    // 2. SUCCESSFUL INITIALIZATION: Use the parsed URL values
    user = User(
      // Use the parsed parameters here!
      name: name,
      email: email,
    );
    courseService = CourseService();
    MockBackend.init(user); // init für user daten etc.
    maxCourses = MockBackend.getMaxCourses();
    selectedCourses = MockBackend.getSelectedCourses();
    hasBeenInitialized = true;

    // This calls itself, but since hasBeenInitialized is now true, it won't re-run initCore.
    selectionDone = isSelectionDoneByUser();
  }

  // --- Public Getters ---

  // New public getter for checking the error state
  String? getInitializationError() {
    return _initializationError;
  }

  User getUser() {
    if (!hasBeenInitialized) initCore();
    // Safety check: if an error occurred, throw or return a null/dummy user
    if (_initializationError != null) {
      throw Exception(_initializationError);
    }
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

  (bool, List<Course>) saveCourses(List<Course> selectedCourses) {
    var (successful, returnedList) = MockBackend.saveCourses(selectedCourses);
    if(successful) selectedCourses = returnedList;
    return (successful, selectedCourses); //here the selectedCourses get updated based on the backendcall
  }
}