import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/services/database_helper.dart';
import 'core/services/secure_storage_service.dart';
import 'data/datasources/session_remote_datasource.dart';
import 'data/repositories/session_repository_impl.dart';
import 'domain/repositories/session_repository.dart';
import 'domain/usecases/get_sessions.dart';
import 'presentation/blocs/session/session_bloc.dart';
import 'presentation/blocs/booking/booking_bloc.dart';

/// Service Locator instance from GetIt.
final sl = GetIt.instance;

/// Initializes the Dependency Injection (DI) container.
/// This method registers all Blocs, Use cases, Repositories, and Services used in the app.
/// It is called once in [main.dart] during application startup.
Future<void> init() async {
  // --- Blocs ---
  // Factories are used for Blocs so a new instance is created whenever requested (disposing state).
  sl.registerFactory(() => SessionBloc(getSessions: sl()));
  sl.registerFactory(() => BookingBloc(repository: sl()));

  // --- Use cases ---
  // LazySingletons ensure these logic components are created only once when first needed.
  sl.registerLazySingleton(() => GetSessions(sl()));

  // --- Repository ---
  // Bridges the Domain layer (interface) with the Data layer (implementation).
  sl.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(
      remoteDataSource: sl(),
      databaseHelper: sl(),
    ),
  );

  // --- Data sources ---
  // Encapsulates logic for external API/mock data fetching.
  sl.registerLazySingleton<SessionRemoteDataSource>(
    () => SessionRemoteDataSourceImpl(),
  );

  // --- Services ---
  // Singleton instances for persistent local storage and database management.
  sl.registerLazySingleton(() => DatabaseHelper());
  sl.registerLazySingleton(() => SecureStorageService(sl()));

  // --- External ---
  // Third-party library instances injected into our service wrappers.
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
