import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../data/models/session_model.dart';

/// Service class responsible for SQLite database management.
/// Handles session caching, booking persistence, and local state management.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  /// Singleton factory constructor.
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  /// Returns the database instance, initializing it if it doesn't exist.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the database on the device.
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'sessions.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Creates tables when the database is first initialized.
  Future<void> _onCreate(Database db, int version) async {
    // Sessions table stores cached data from the API
    await db.execute('''
      CREATE TABLE sessions(
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        instructor TEXT,
        startTime TEXT,
        duration INTEGER,
        status TEXT,
        imageUrl TEXT,
        category TEXT,
        isBooked INTEGER,
        hasJoined INTEGER DEFAULT 0
      )
    ''');
    
    // Bookings table for tracking user registrations
    await db.execute('''
      CREATE TABLE bookings(
        sessionId TEXT PRIMARY KEY
      )
    ''');
  }

  /// Handles database schema updates (e.g., adding hasJoined column).
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE sessions ADD COLUMN hasJoined INTEGER DEFAULT 0');
    }
  }

  /// Saves a list of session models to the local database.
  /// Uses "UPSERT" logic to update existing records while preserving local-only data.
  Future<void> cacheSessions(List<SessionModel> sessions) async {
    final db = await database;
    Batch batch = db.batch();
    for (var session in sessions) {
      batch.execute('''
        INSERT INTO sessions (id, title, description, instructor, startTime, duration, status, imageUrl, category, isBooked, hasJoined)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ON CONFLICT(id) DO UPDATE SET
          title=excluded.title,
          description=excluded.description,
          instructor=excluded.instructor,
          startTime=excluded.startTime,
          duration=excluded.duration,
          status=excluded.status,
          imageUrl=excluded.imageUrl,
          category=excluded.category,
          isBooked=MAX(sessions.isBooked, excluded.isBooked)
      ''', [
        session.id,
        session.title,
        session.description,
        session.instructor,
        session.startTime.toIso8601String(),
        session.duration,
        session.status,
        session.imageUrl,
        session.category,
        session.isBooked ? 1 : 0,
        session.hasJoined ? 1 : 0,
      ]);
    }
    await batch.commit(noResult: true);
  }

  /// Retrieves all cached sessions from the database.
  Future<List<SessionModel>> getCachedSessions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sessions');
    return List.generate(maps.length, (i) {
      return SessionModel.fromJson({
        ...maps[i],
        'isBooked': maps[i]['isBooked'] == 1,
        'hasJoined': maps[i]['hasJoined'] == 1,
      });
    });
  }

  /// Records a session booking and updates its status in the cache.
  Future<void> insertBooking(String sessionId) async {
    final db = await database;
    await db.insert(
      'bookings',
      {'sessionId': sessionId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    await db.update(
      'sessions',
      {'isBooked': 1},
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  /// Persistently marks a session as "joined" to handle REJOIN logic.
  Future<void> markSessionAsJoined(String sessionId) async {
    final db = await database;
    await db.update(
      'sessions',
      {'hasJoined': 1},
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  /// Returns a list of all session IDs that have been booked by the user.
  Future<List<String>> getBookedSessionIds() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bookings');
    return List.generate(maps.length, (i) => maps[i]['sessionId'] as String);
  }
}
