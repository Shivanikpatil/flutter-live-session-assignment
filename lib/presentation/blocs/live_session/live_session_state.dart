import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat_message.dart';

/// Represents the state of the Live Session screen.
/// Part of the Presentation layer, managed by [LiveSessionBloc].
class LiveSessionState extends Equatable {
  /// Total seconds elapsed since the user joined the live session.
  final int secondsElapsed;
  
  /// List of all chat messages received or sent during this session.
  final List<ChatMessage> messages;
  
  /// Current number of participants watching the session.
  final int participantCount;

  const LiveSessionState({
    this.secondsElapsed = 0,
    this.messages = const [],
    this.participantCount = 42,
  });

  /// Creates a copy of the state with updated values.
  /// [secondsElapsed] updated duration of the live session.
  /// [messages] new list of chat messages.
  /// [participantCount] updated number of viewers.
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

  /// Helper getter to convert [secondsElapsed] into a human-readable MM:SS format.
  String get formattedDuration {
    final minutes = secondsElapsed ~/ 60;
    final remainingSeconds = secondsElapsed % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  List<Object> get props => [secondsElapsed, messages, participantCount];
}
