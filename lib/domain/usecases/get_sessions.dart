import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/session.dart';
import '../repositories/session_repository.dart';

/// Use case for fetching all available sessions.
/// Following Clean Architecture, this class encapsulates the specific business logic for retrieval.
class GetSessions {
  final SessionRepository repository;

  GetSessions(this.repository);

  /// Executes the use case.
  /// Returns either a [Failure] or a list of [Session] entities.
  Future<Either<Failure, List<Session>>> call() async {
    return await repository.getSessions();
  }
}
