import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class BookSessionEvent extends BookingEvent {
  final String sessionId;
  const BookSessionEvent(this.sessionId);

  @override
  List<Object> get props => [sessionId];
}

class FetchBookedSessionsEvent extends BookingEvent {}

class JoinSessionEvent extends BookingEvent {
  final String sessionId;
  const JoinSessionEvent(this.sessionId);

  @override
  List<Object> get props => [sessionId];
}
