import 'package:equatable/equatable.dart';

/// Represents a single chat message sent during a live session.
/// Part of the Domain layer.
class ChatMessage extends Equatable {
  /// Unique identifier for the message.
  final String id;
  
  /// The display name of the user who sent the message.
  final String senderName;
  
  /// The text content of the message.
  final String message;
  
  /// The time when the message was sent.
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.senderName,
    required this.message,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, senderName, message, timestamp];
}
