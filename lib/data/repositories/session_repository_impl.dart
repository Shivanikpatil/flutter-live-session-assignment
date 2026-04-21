import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/session_remote_datasource.dart';
import '../../core/services/database_helper.dart';

/// Implementation of [SessionRepository].
/// Coordinates between [SessionRemoteDataSource] and [DatabaseHelper] to provide an offline-first data strategy.
class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDataSource remoteDataSource;
  final DatabaseHelper databaseHelper;

  SessionRepositoryImpl({
    required this.remoteDataSource,
    required this.databaseHelper,
  });

  /// Fetches sessions from the remote data source and caches them locally.
  /// If the network fails, it attempts to return the locally cached data.
  @override
  Future<Either<Failure, List<Session>>> getSessions() async {
    try {
      // 1. Try to get fresh data from the mock API
      final remoteSessions = await remoteDataSource.getSessions();
      
      // 2. Cache the new data in SQLite
      await databaseHelper.cacheSessions(remoteSessions);
      
      // 3. Return the merged data (cached sessions + booking state)
      final localSessions = await databaseHelper.getCachedSessions();
      return Right(localSessions);
    } catch (e) {
      // 4. Fallback: If network error, try to serve from local database
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

  /// Marks a session as booked in the local database.
  /// [sessionId] The unique ID of the session to book.
  @override
  Future<Either<Failure, void>> bookSession(String sessionId) async {
    try {
      await databaseHelper.insertBooking(sessionId);
      return const Right(null);
    } catch (e) {
      return const Left(DatabaseFailure('Failed to book session'));
    }
  }

  /// Retrieves all sessions that have been marked as booked by the user.
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

  /// Marks a session as "joined" in the local database.
  /// [sessionId] The unique ID of the live session.
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
