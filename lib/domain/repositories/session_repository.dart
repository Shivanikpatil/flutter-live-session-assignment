import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/session.dart';

abstract class SessionRepository {
  Future<Either<Failure, List<Session>>> getSessions();
  Future<Either<Failure, void>> bookSession(String sessionId);
  Future<Either<Failure, List<Session>>> getBookedSessions();
  Future<Either<Failure, void>> joinSession(String sessionId);
}
