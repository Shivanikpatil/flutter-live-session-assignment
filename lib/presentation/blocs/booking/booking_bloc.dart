import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/session_repository.dart';
import 'booking_event.dart';
import 'booking_state.dart';

/// Business Logic Component for managing session bookings and join status.
/// This Bloc handles the logic of registering for a session and marking a session as joined.
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final SessionRepository repository;

  BookingBloc({required this.repository}) : super(BookingInitial()) {
    // Register event handlers for booking and joining logic
    on<BookSessionEvent>(_onBookSession);
    on<FetchBookedSessionsEvent>(_onFetchBookedSessions);
    on<JoinSessionEvent>(_onJoinSession);
  }

  /// Handles the [BookSessionEvent] to register a user for a specific session.
  /// [event.sessionId] unique identifier of the session.
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

  /// Fetches all sessions the user has already booked.
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

  /// Handles the [JoinSessionEvent] to mark a session as joined (persistent state).
  /// This enables the "REJOIN" functionality.
  Future<void> _onJoinSession(
    JoinSessionEvent event,
    Emitter<BookingState> emit,
  ) async {
    final result = await repository.joinSession(event.sessionId);
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (_) => null, // State is typically refreshed in the UI via SessionBloc
    );
  }
}
