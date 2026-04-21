import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat_message.dart';

abstract class LiveSessionEvent extends Equatable {
  const LiveSessionEvent();

  @override
  List<Object> get props => [];
}

class StartSession extends LiveSessionEvent {}

class TimerTicked extends LiveSessionEvent {
  final int duration;
  const TimerTicked(this.duration);

  @override
  List<Object> get props => [duration];
}

class NewMessageReceived extends LiveSessionEvent {
  final ChatMessage message;
  const NewMessageReceived(this.message);

  @override
  List<Object> get props => [message];
}

class SendMessageEvent extends LiveSessionEvent {
  final String message;
  const SendMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}
