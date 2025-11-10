import 'package:flutter/material.dart';
import 'package:wapfau/models/user.dart';
import 'package:wapfau/services/coreService.dart';
import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/courseService.dart';
import '../widgets/card.dart';
import '../widgets/searchbar.dart';
import '../widgets/selectedCoursesCard.dart';

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
  late List<Course> activeSelection;

  String _query = '';

  // --- Scroll / Swap-Logik ---
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _listHeaderKey = GlobalKey(); // misst die SelectedCoursesCaard IN der Liste
  double _listHeaderHeight = 0;                 // dynamisch (abhängig von Auswahl)
  bool _showPinnedSummary = false;

  // Konstanten, passend zu deinem ListView
  static const EdgeInsets _listPadding =
  EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8);
  static const double _separatorHeight = 12;

  @override
  void initState() {
    super.initState();
    activeSelection = List.from(widget.coreService.selectedCourses);
    maxCourses = widget.coreService.getMaxCourses();
    user = widget.coreService.getUser();
    courseService = widget.coreService.getCourseService();
    courses = courseService.getAllCourses();

    _scrollController.addListener(_onScroll);

    // Nach dem ersten Build die Header-Höhe messen
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureListHeader());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSelection(Course c) {
    setState(() {
      if (activeSelection.contains(c)) {
        activeSelection.remove(c);
      } else if (activeSelection.length < maxCourses &&( widget.coreService.selectedCoursesContains(c) || (c.availableSlots - c.reservedSlots) > 0)) {
        activeSelection.add(c);
      }
    });
    // Header kann sich in der Höhe ändern -> neu messen, wenn sichtbar
    if (!_showPinnedSummary) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureListHeader());
    }
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

  // --- Scroll / Swap ---
  void _onScroll() {
    // Schwelle: Höhe der SelectedCoursesCaard (in der Liste)
    // + ein Separator darunter + ListView.top-Padding
    final double threshold = _listHeaderHeight + _separatorHeight + _listPadding.top;

    final bool shouldShowPinned = _scrollController.offset >= threshold - 0.9;
    if (shouldShowPinned != _showPinnedSummary) {
      setState(() => _showPinnedSummary = shouldShowPinned);
    }
  }

  void _measureListHeader() {
    final ctx = _listHeaderKey.currentContext;
    if (ctx == null) return;
    final RenderObject? ro = ctx.findRenderObject();
    if (ro is RenderBox) {
      final h = ro.size.height;
      if ((h - _listHeaderHeight).abs() > 0.5) {
        setState(() => _listHeaderHeight = h);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSearchVisible = !_showPinnedSummary;
    // Wenn die Zusammenfassung oben "angepinnt" wird,
    // zeigen wir sie NICHT zusätzlich in der Liste.
    final bool includeHeaderInList = !_showPinnedSummary;
    final int itemCount = _filteredCourses.length + (includeHeaderInList ? 1 : 0);

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 8),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            // This transition is for the switch between the SearchBar
            // and the Pinned Summary, when the SearchBar *would* be in
            // the same spot. Since they are stacked vertically, let's use a FadeThrough.
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
              // Or use a more complex one like FadeThroughTransition from package:animations
            },
            child: isSearchVisible
                ? // Key is essential for AnimatedSwitcher to work
            Column(
              key: const ValueKey('searchBarArea'),
              children: [
                AnimatedOpacity(
                  // Key change: Use a standard duration for the opacity.
                  duration: const Duration(milliseconds: 250),
                  opacity: isSearchVisible ? 1.0 : 0.0,
                  // Visibility is crucial here: if we set it to false when opacity is 0,
                  // it won't take up space, achieving the "disappear" effect.
                  child: isSearchVisible
                      ? CourseSearchBar(
                    key: const ValueKey('searchbar'),
                    onQueryChanged: (q) => setState(() => _query = q),
                    initialQuery: _query,
                    hintText: 'Module, Dozent:in oder Beschreibung…',
                  )
                      : const SizedBox.shrink(),
                ),
                SelectedCoursesCard(
                  key: const ValueKey('pinnedSummary-always-visible'),
                  selected: activeSelection,
                  pinnedb: false,
                  maxCourses: maxCourses,
                  coreService: widget.coreService,
                  onRemoveCourse: (c) => _toggleSelection(c),
                ),
              ],
            )
                : // Pinned State: Only the SelectedCoursesCard is shown
            SelectedCoursesCard(
              // Key must be different from the 'searchBarArea' one.
              key: const ValueKey('pinnedSummary-only'),
              selected: activeSelection,
              pinnedb: true,
              maxCourses: maxCourses,
              coreService: widget.coreService,
              onRemoveCourse: (c) => _toggleSelection(c),
            ),
          ),

          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              padding: _listPadding,
              // The itemCount is now just the number of filtered courses
              itemCount: _filteredCourses.length,
              separatorBuilder: (_, __) => const SizedBox(height: _separatorHeight),
              itemBuilder: (context, i) {
                final course = _filteredCourses[i];
                final isSelected = activeSelection.contains(course);

                return CourseCard(
                  course: course,
                  isSelected: isSelected,
                  onToggleSelect: () => _toggleSelection(course),
                  canBeChosen: (widget.coreService.selectedCoursesContains(course) || ((course.availableSlots - course.reservedSlots) > 0)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
