import 'package:flutter/material.dart';
import 'package:wapfau/assets/colors.dart';

import '../models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final bool isSelected;
  final VoidCallback onToggleSelect;
  final bool canBeChosen;

  const CourseCard({
    super.key,
    required this.course,
    required this.isSelected,
    required this.onToggleSelect,
    required this.canBeChosen
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final seatsLeft =
    (course.availableSlots - course.reservedSlots).clamp(-9999, 9999);

    Color normalBg = isSelected ? AppColors.primaryRed : Colors.black87;
    Color ectsColor = isSelected ? Colors.white : Colors.black87;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            border: Border.all(
              //color: Color(0xFFD4183D).withOpacity(0.1),
              color: isSelected ?  Colors.black87.withOpacity(1) : Colors.black87.withOpacity(0.1),
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
                Container( //ects container
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : AppColors.courseUnselectedEctsBg,//theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${course.ects} ECTS',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: ectsColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              course.description,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textGrey,
              ),
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
                    style: TextStyle(
                      color: AppColors.textGrey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.schedule, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('LVZ: ${course.lvz}',
                    softWrap: true, overflow: TextOverflow.visible,
                    style: TextStyle(
                      color: AppColors.textGrey,
                    ),
                  ),

                ),
              ],
            ),
            const SizedBox(height: 12),
            if (seatsLeft > 0)
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  //color: Colors.red.shade700,
                  color: Color(0xFFD4183D),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$seatsLeft Plätze frei',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(color: Colors.white),
                ),
              )
            else
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.disabledColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                Text('Ausgebucht', style: theme.textTheme.labelLarge),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onToggleSelect,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // text & icon
                  backgroundColor: normalBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ).copyWith(
                  // pressed state should be red
                  backgroundColor:
                  WidgetStateProperty.resolveWith<Color>((states) {
                    return normalBg;
                  }),
                ),
                child: Text(isSelected ? 'Ausgewählt' : 'Auswählen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
