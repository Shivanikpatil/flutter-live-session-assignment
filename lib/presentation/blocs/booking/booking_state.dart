import 'package:equatable/equatable.dart';
import '../../../domain/entities/session.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final String message;
  const BookingSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class BookedSessionsLoaded extends BookingState {
  final List<Session> sessions;
  const BookedSessionsLoaded(this.sessions);

  @override
  List<Object> get props => [sessions];
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);

  @override
  List<Object> get props => [message];
}
