import 'package:equatable/equatable.dart';

class Session extends Equatable {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final DateTime startTime;
  final int duration;
  final String status; // upcoming, live, completed
  final String imageUrl;
  final String category;
  final bool isBooked;
  final bool hasJoined;

  const Session({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.startTime,
    required this.duration,
    required this.status,
    required this.imageUrl,
    required this.category,
    this.isBooked = false,
    this.hasJoined = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        instructor,
        startTime,
        duration,
        status,
        imageUrl,
        category,
        isBooked,
        hasJoined,
      ];
}
