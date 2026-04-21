import 'package:equatable/equatable.dart';
import '../../../domain/entities/session.dart';

abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object> get props => [];
}

class SessionInitial extends SessionState {}

class SessionLoading extends SessionState {}

class SessionLoaded extends SessionState {
  final List<Session> sessions;
  final String selectedCategory;

  const SessionLoaded({required this.sessions, this.selectedCategory = 'All'});

  List<Session> get filteredSessions {
    if (selectedCategory == 'All') return sessions;
    if (selectedCategory == 'Live') {
      return sessions.where((s) => s.status.toLowerCase() == 'live').toList();
    }
    return sessions.where((s) => s.category == selectedCategory).toList();
  }

  @override
  List<Object> get props => [sessions, selectedCategory];
}

class SessionError extends SessionState {
  final String message;
  const SessionError(this.message);

  @override
  List<Object> get props => [message];
}
