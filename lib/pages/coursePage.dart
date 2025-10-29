import 'package:flutter/material.dart';
import 'package:wapfau/models/user.dart';
import 'package:wapfau/services/coreService.dart';

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
  // --- State / Services ---
  late int maxCourses;
  late User user;
  late CourseService courseService;
  late List<Course> courses;
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

  // --- Auswahl-Handling ---
  void _toggleSelection(Course c) {
    setState(() {
      if (widget.coreService.selectedCourses.contains(c)) {
        widget.coreService.selectedCourses.remove(c);
      } else if (widget.coreService.selectedCourses.length < maxCourses) {
        widget.coreService.selectedCourses.add(c);
      }
    });

    // Header kann sich in der Höhe ändern -> neu messen, wenn sichtbar
    if (!_showPinnedSummary) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureListHeader());
    }
  }

  // --- Suche (null-sicher) ---
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

    final bool shouldShowPinned = _scrollController.offset >= threshold - 0.5;
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
    final selected = widget.coreService.selectedCourses;
    // Wenn die Zusammenfassung oben "angepinnt" wird,
    // zeigen wir sie NICHT zusätzlich in der Liste.
    final bool includeHeaderInList = !_showPinnedSummary;
    final int itemCount = _filteredCourses.length + (includeHeaderInList ? 1 : 0);

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),

          // Oberer Bereich: SearchBar ODER (wenn gescrollt) die SelectedCoursesCaard
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: _showPinnedSummary
                ? SelectedCoursesCard(
              key: const ValueKey('pinnedSummary'),
              selected: selected,
              pinnedb: true,
              maxCourses: maxCourses,
              onRemoveCourse: (c) => _toggleSelection(c),
            )
                : CourseSearchBar(
              key: const ValueKey('searchbar'),
              onQueryChanged: (q) => setState(() => _query = q),
              initialQuery: _query,
              hintText: 'Module, Dozent:in oder Beschreibung…',
            ),
          ),

          // Scroll-Liste: ggf. mit Header als erstem Eintrag
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              padding: _listPadding,
              itemCount: itemCount,
              separatorBuilder: (_, __) => const SizedBox(height: _separatorHeight),
              itemBuilder: (context, i) {
                // 1) Optionaler Header „Gewählte Module“, scrollt mit
                if (includeHeaderInList && i == 0) {
                  return KeyedSubtree(
                    // Key zum Messen der Höhe dieses Headers
                    key: _listHeaderKey,
                    child: SelectedCoursesCard(
                      selected: selected,
                      pinnedb: false,
                      maxCourses: maxCourses,
                      onRemoveCourse: (c) => _toggleSelection(c),
                    ),
                  );
                }

                // 2) Kurskarten
                final int courseIndex = includeHeaderInList ? i - 1 : i;
                final course = _filteredCourses[courseIndex];
                final isSelected = selected.contains(course);

                return CourseCard(
                  course: course,
                  isSelected: isSelected,
                  onToggleSelect: () => _toggleSelection(course),
                  canBeChosen: selected.length < maxCourses,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
