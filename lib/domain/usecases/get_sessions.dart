import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/session.dart';
import '../repositories/session_repository.dart';

class GetSessions {
  final SessionRepository repository;

  GetSessions(this.repository);

  Future<Either<Failure, List<Session>>> call() async {
    return await repository.getSessions();
  }
}
