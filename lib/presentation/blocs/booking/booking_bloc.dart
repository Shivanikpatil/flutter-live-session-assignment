import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/session_repository.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final SessionRepository repository;

  BookingBloc({required this.repository}) : super(BookingInitial()) {
    on<BookSessionEvent>(_onBookSession);
    on<FetchBookedSessionsEvent>(_onFetchBookedSessions);
    on<JoinSessionEvent>(_onJoinSession);
  }

  Future<void> _onBookSession(
    BookSessionEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await repository.bookSession(event.sessionId);
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (_) => emit(const BookingSuccess('Session booked successfully!')),
    );
  }

  Future<void> _onFetchBookedSessions(
    FetchBookedSessionsEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await repository.getBookedSessions();
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (sessions) => emit(BookedSessionsLoaded(sessions)),
    );
  }

  Future<void> _onJoinSession(
    JoinSessionEvent event,
    Emitter<BookingState> emit,
  ) async {
    final result = await repository.joinSession(event.sessionId);
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (_) => null, // Success is handled by UI navigation/refresh
    );
  }
}
