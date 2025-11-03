
import 'package:flutter/cupertino.dart';

@immutable
class Course {
  final String id;
  final String title;
  final int ects;
  final String description;
  final String prof;
  final int lvz;
  final int availableSlots;
  final int reservedSlots;

  const Course({
    required this.id,
    required this.title,
    required this.ects,
    required this.description,
    required this.prof,
    required this.lvz,
    required this.availableSlots,
    required this.reservedSlots,
  });

  // Equality by id -> enables List.contains(course)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Course && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
