import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String senderName;
  final String message;
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
