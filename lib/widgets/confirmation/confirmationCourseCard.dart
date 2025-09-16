import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../models/course.dart';

class ConfirmationCourseCard extends StatelessWidget {
  final Course course;
  const ConfirmationCourseCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: Container(
         padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.03),
            border: Border.all(
              color: Colors.black.withOpacity(0.1),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12)
        ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisSize: MainAxisSize.min,
           children: [
             Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Expanded(
                   child: Text(
                     course.title,
                     softWrap: true,
                     overflow: TextOverflow.visible,
                     style: theme.textTheme.titleMedium?.copyWith(
                       fontWeight: FontWeight.w700,
                     ),
                   ),
                 ),
                 const SizedBox(width: 12),
                 Container(
                   padding:
                   const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                   decoration: BoxDecoration(
                     color: theme.colorScheme.surfaceContainerHighest,
                     borderRadius: BorderRadius.circular(999),
                   ),
                   child: Text('${course.ects} ECTS',
                       style: theme.textTheme.labelMedium),
                 ),
               ],
             ),
             const SizedBox(height: 8),
             Text(
               course.description,
               softWrap: true,
               overflow: TextOverflow.visible,
               style: theme.textTheme.bodyMedium,
             ),
             const SizedBox(height: 12),
             Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const Icon(Icons.person, size: 18),
                 const SizedBox(width: 8),
                 Expanded(
                   child: Text(
                     course.prof,
                     softWrap: true,
                     overflow: TextOverflow.visible,
                   ),
                 ),
               ],
             ),
           ],
         ),
       ),
    );
  }
}
