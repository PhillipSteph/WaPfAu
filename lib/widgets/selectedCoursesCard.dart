import 'package:flutter/material.dart';
import 'package:wapfau/models/course.dart';


import 'package:flutter/material.dart';
import 'package:wapfau/services/coreService.dart';

import '../../models/course.dart';
import '../../pages/coursePage.dart';
import '../pages/confirmationPage.dart';

/// Karte im Stil "Gewählte Module" mit:
/// - Überschrift + Zähler (x / max)
/// - ECTS-Gesamt + Fortschrittsbalken
/// - Liste der ausgewählten Module als kleine Chips/Karten mit Entfernen-Icon
class SelectedCoursesCard extends StatelessWidget {
  const SelectedCoursesCard({
    super.key,
    this.pinnedb = false,
    required this.selected,
    required this.maxCourses,
    required this.onRemoveCourse,
    required this.coreService,
    this.tagOf, // optionales Tag (z. B. Fachbereich) – wird nur angezeigt, wenn vorhanden
    this.title = 'Gewählte Module',
  });

  final bool pinnedb;
  final List<Course> selected;
  final int maxCourses;
  final void Function(Course course) onRemoveCourse;
  final String Function(Course course)? tagOf;
  final String title;
  final CoreService coreService;

  double get _totalEcts => selected.length / maxCourses;
  int get _count => selected.length;
  int get _remaining => (maxCourses - _count).clamp(0, 999);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = maxCourses > 0 ? _count / maxCourses : 0.0;

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
      child: Card(
        elevation: 0,
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.dividerColor.withOpacity(0.5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Titel + Zähler
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: pinnedb ? theme.textTheme.titleSmall : theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text('$_count / $maxCourses', style: pinnedb ? theme.textTheme.titleSmall : theme.textTheme.titleMedium),
                ],
              ),
              if(!pinnedb) const SizedBox(height: 12),
              if(pinnedb) SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  color: Colors.black87,
                ),
              ),

              if(!pinnedb)
                  Column(
                    children: [
                      SizedBox(height: 8),

                      Text(
                        _remaining > 0
                            ? 'Sie benötigen noch $_remaining weitere Module.'
                            : 'Sie haben die maximale Anzahl an Modulen gewählt.',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                      )
                    ],
                  ),
              // Liste der gewählten Module
              if (selected.isNotEmpty) const SizedBox(height: 12),
              ...selected.map((c) => _ChosenCourseTile(
                course: c,
                onRemove: () => onRemoveCourse(c),
                pinnedb: pinnedb,
              )
              ),
              if (!pinnedb) SizedBox(height: 10),
              if (!pinnedb) SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  var (wasSuccessful, returnedList) = coreService.saveCourses(selected);
                  //returns true if succeeded to save
                  if(wasSuccessful){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                            body: Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 600,
                                  ),
                                  child: ConfirmationPage(coreService: coreService),
                                )
                            )
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // text & icon
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ).copyWith(
                  // pressed state should be red
                  backgroundColor:
                  WidgetStateProperty.resolveWith<Color>((states) {
                    if (selected.length==coreService.getMaxCourses()) {
                      return Colors.green.shade700;
                    }
                    return Colors.grey;
                  }),
                ),
                  child: Text('Kurse wählen'),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class _ChosenCourseTile extends StatelessWidget {
  const _ChosenCourseTile({
    required this.course,
    required this.onRemove,
    this.pinnedb = false
  });

  final bool pinnedb;
  final Course course;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Dynamic styles based on pinnedb
    final double verticalMargin = pinnedb ? 4 : 8;
    final double tilePadding = pinnedb ? 8 : 12;
    final double titleFontSize = pinnedb ? 12 : 16;
    final FontWeight titleFontWeight = pinnedb ? FontWeight.normal : FontWeight.w600;
    final double iconSize = pinnedb ? 18 : 22; // Keeping the icon size constant for clarity

    return Container(
      height: pinnedb ? 34 : 48,
      // Smaller top margin when pinned
      margin: EdgeInsets.only(top: verticalMargin),
      // Smaller padding when pinned
      padding: EdgeInsets.all(tilePadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Titel + Chips
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    // Smaller and not bold when pinned
                    fontSize: titleFontSize,
                    fontWeight: titleFontWeight,
                  ),
                ),
                // The SizedBox is hidden when pinned (already in the original code)
              ],
            ),
          ),
          // Entfernen
          IconButton(
            tooltip: 'Entfernen',
            onPressed: onRemove,
            icon: const Icon(Icons.close),
            splashRadius: 18,
            // Constraints ensure it doesn't take up too much space.
            constraints: const BoxConstraints(),
            iconSize: iconSize,
            // Reduce padding to keep it close to the text
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}