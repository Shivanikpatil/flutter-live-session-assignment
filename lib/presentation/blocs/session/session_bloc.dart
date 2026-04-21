import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_sessions.dart';
import 'session_event.dart';
import 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final GetSessions getSessions;

  SessionBloc({required this.getSessions}) : super(SessionInitial()) {
    on<FetchSessions>(_onFetchSessions);
    on<FilterSessions>(_onFilterSessions);
  }

  Future<void> _onFetchSessions(
    FetchSessions event,
    Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading());
    final result = await getSessions();
    result.fold(
      (failure) => emit(SessionError(failure.message)),
      (sessions) => emit(SessionLoaded(sessions: sessions)),
    );
  }

  void _onFilterSessions(
    FilterSessions event,
    Emitter<SessionState> emit,
  ) {
    if (state is SessionLoaded) {
      final currentState = state as SessionLoaded;
      emit(SessionLoaded(
        sessions: currentState.sessions,
        selectedCategory: event.category,
      ));
    }
  }
}
