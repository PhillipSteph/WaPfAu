import 'package:flutter/material.dart';
import 'package:wapfau/models/course.dart';

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
    this.tagOf, // optionales Tag (z. B. Fachbereich) – wird nur angezeigt, wenn vorhanden
    this.title = 'Gewählte Module',
  });

  final bool pinnedb;
  final List<Course> selected;
  final int maxCourses;
  final void Function(Course course) onRemoveCourse;
  final String Function(Course course)? tagOf;
  final String title;

  int get _totalEcts => selected.fold<int>(0, (sum, c) => sum + (c.ects));
  int get _count => selected.length;
  int get _remaining => (maxCourses - _count).clamp(0, 999);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = maxCourses > 0 ? _count / maxCourses : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text('$_count / $maxCourses', style: theme.textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 8),

              // ECTS + Progress
              Row(
                children: [
                  Text('ECTS-Punkte:', style: theme.textTheme.bodyMedium),
                  const SizedBox(width: 8),
                  Text('$_totalEcts', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                _remaining > 0
                    ? 'Sie benötigen noch $_remaining weitere Module.'
                    : 'Sie haben die maximale Anzahl an Modulen gewählt.',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
              ),

              // Liste der gewählten Module
              if (selected.isNotEmpty) const SizedBox(height: 12),
              ...selected.map((c) => _ChosenCourseTile(
                course: c,
                onRemove: () => onRemoveCourse(c),
                pinnedb: pinnedb,
              )),
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
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titel + Chips
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(course.title,
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                pinnedb ?
                const SizedBox.shrink():
                const SizedBox(height: 6),

                pinnedb ?
                const SizedBox.shrink():
                Chip(
                  label: Text('${course.ects} ECTS', style: theme.textTheme.labelMedium),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(color: theme.dividerColor),
                  backgroundColor: theme.colorScheme.surface,
                ),
              ],
            ),
          ),

          // Entfernen
          IconButton(
            tooltip: 'Entfernen',
            onPressed: onRemove,
            icon: const Icon(Icons.close),
            splashRadius: 18,
            constraints: const BoxConstraints(),
            iconSize: 18,
            padding: EdgeInsetsGeometry.all(0),
          ),
        ],
      ),
    );
  }
}
