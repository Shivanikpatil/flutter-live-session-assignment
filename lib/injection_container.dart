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

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => SessionBloc(getSessions: sl()));
  sl.registerFactory(() => BookingBloc(repository: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetSessions(sl()));

  // Repository
  sl.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(
      remoteDataSource: sl(),
      databaseHelper: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<SessionRemoteDataSource>(
    () => SessionRemoteDataSourceImpl(),
  );

  // Services
  sl.registerLazySingleton(() => DatabaseHelper());
  sl.registerLazySingleton(() => SecureStorageService(sl()));

  // External
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
