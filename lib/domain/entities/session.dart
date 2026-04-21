import 'package:equatable/equatable.dart';

/// The core Business Entity representing a session.
/// This class is defined in the Domain layer and is independent of any data formats or frameworks.
class Session extends Equatable {
  /// Unique identifier for the session.
  final String id;
  
  /// The title of the session (e.g., "Morning Yoga Flow").
  final String title;
  
  /// A detailed description of what the session involves.
  final String description;
  
  /// The name of the instructor leading the session.
  final String instructor;
  
  /// The scheduled start date and time.
  final DateTime startTime;
  
  /// Duration of the session in minutes.
  final int duration;
  
  /// Current status: "upcoming", "live", or "completed".
  final String status;
  
  /// URL to the session's cover image.
  final String imageUrl;
  
  /// Category of the session (e.g., "Yoga", "Fitness", "Meditation").
  final String category;
  
  /// Indicates if the current user has booked this session.
  final bool isBooked;
  
  /// Indicates if the user has ever joined this session (used for REJOIN logic).
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
