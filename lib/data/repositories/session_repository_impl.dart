import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/session_remote_datasource.dart';
import '../../core/services/database_helper.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDataSource remoteDataSource;
  final DatabaseHelper databaseHelper;

  SessionRepositoryImpl({
    required this.remoteDataSource,
    required this.databaseHelper,
  });

  @override
  Future<Either<Failure, List<Session>>> getSessions() async {
    try {
      final remoteSessions = await remoteDataSource.getSessions();
      await databaseHelper.cacheSessions(remoteSessions);
      
      final localSessions = await databaseHelper.getCachedSessions();
      return Right(localSessions);
    } catch (e) {
      try {
        final localSessions = await databaseHelper.getCachedSessions();
        if (localSessions.isNotEmpty) {
          return Right(localSessions);
        }
        return const Left(CacheFailure('No cached data available'));
      } catch (e) {
        return const Left(DatabaseFailure('Database error'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> bookSession(String sessionId) async {
    try {
      await databaseHelper.insertBooking(sessionId);
      return const Right(null);
    } catch (e) {
      return const Left(DatabaseFailure('Failed to book session'));
    }
  }

  @override
  Future<Either<Failure, List<Session>>> getBookedSessions() async {
    try {
      final sessions = await databaseHelper.getCachedSessions();
      final bookedSessions = sessions.where((s) => s.isBooked).toList();
      return Right(bookedSessions);
    } catch (e) {
      return const Left(DatabaseFailure('Failed to fetch booked sessions'));
    }
  }

  @override
  Future<Either<Failure, void>> joinSession(String sessionId) async {
    try {
      await databaseHelper.markSessionAsJoined(sessionId);
      return const Right(null);
    } catch (e) {
      return const Left(DatabaseFailure('Failed to join session'));
    }
  }
}
