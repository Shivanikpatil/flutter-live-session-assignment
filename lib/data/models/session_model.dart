import '../../domain/entities/session.dart';

class SessionModel extends Session {
  const SessionModel({
    required super.id,
    required super.title,
    required super.description,
    required super.instructor,
    required super.startTime,
    required super.duration,
    required super.status,
    required super.imageUrl,
    required super.category,
    super.isBooked,
    super.hasJoined,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      instructor: json['instructor'],
      startTime: DateTime.parse(json['startTime']),
      duration: json['duration'],
      status: json['status'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      isBooked: json['isBooked'] is bool 
          ? json['isBooked'] 
          : (json['isBooked'] == 1),
      hasJoined: json['hasJoined'] is bool 
          ? json['hasJoined'] 
          : (json['hasJoined'] == 1),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructor': instructor,
      'startTime': startTime.toIso8601String(),
      'duration': duration,
      'status': status,
      'imageUrl': imageUrl,
      'category': category,
      'isBooked': isBooked ? 1 : 0,
      'hasJoined': hasJoined ? 1 : 0,
    };
  }

  SessionModel copyWith({
    bool? isBooked, 
    bool? hasJoined,
    DateTime? startTime,
  }) {
    return SessionModel(
      id: id,
      title: title,
      description: description,
      instructor: instructor,
      startTime: startTime ?? this.startTime,
      duration: duration,
      status: status,
      imageUrl: imageUrl,
      category: category,
      isBooked: isBooked ?? this.isBooked,
      hasJoined: hasJoined ?? this.hasJoined,
    );
  }
}
