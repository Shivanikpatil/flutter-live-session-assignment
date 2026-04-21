import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
/// Used to pass error messages from the data/domain layers to the presentation layer.
abstract class Failure extends Equatable {
  /// A user-friendly error message.
  final String message;
  
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Represents failures related to remote server or API operations.
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Represents failures when retrieving or saving data to the local cache.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Represents failures during SQLite database operations.
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}
