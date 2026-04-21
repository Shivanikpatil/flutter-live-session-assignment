import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat_message.dart';

class LiveSessionState extends Equatable {
  final int secondsElapsed;
  final List<ChatMessage> messages;
  final int participantCount;

  const LiveSessionState({
    this.secondsElapsed = 0,
    this.messages = const [],
    this.participantCount = 42,
  });

  LiveSessionState copyWith({
    int? secondsElapsed,
    List<ChatMessage>? messages,
    int? participantCount,
  }) {
    return LiveSessionState(
      secondsElapsed: secondsElapsed ?? this.secondsElapsed,
      messages: messages ?? this.messages,
      participantCount: participantCount ?? this.participantCount,
    );
  }

  String get formattedDuration {
    final minutes = secondsElapsed ~/ 60;
    final remainingSeconds = secondsElapsed % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  List<Object> get props => [secondsElapsed, messages, participantCount];
}
