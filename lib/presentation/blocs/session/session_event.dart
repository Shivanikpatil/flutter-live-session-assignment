import 'package:equatable/equatable.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object> get props => [];
}

class FetchSessions extends SessionEvent {}

class FilterSessions extends SessionEvent {
  final String category;
  const FilterSessions(this.category);

  @override
  List<Object> get props => [category];
}
