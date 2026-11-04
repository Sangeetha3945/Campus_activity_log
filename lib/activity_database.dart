import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Opens the local SQLite database and provides activity data operations.
class ActivityDatabase {
  ActivityDatabase._();

  static final ActivityDatabase instance = ActivityDatabase._();

  static const _databaseName = 'campus_activity.db';
  static const _tableName = 'activities';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            activity_name TEXT NOT NULL,
            activity_type TEXT NOT NULL,
            activity_date TEXT NOT NULL,
            notes TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  // Insert a new activity.
  Future<int> insertActivity({
    required String activityName,
    required String activityType,
    required String activityDate,
    required String notes,
  }) async {
    final db = await database;

    return await db.insert(_tableName, {
      'activity_name': activityName,
      'activity_type': activityType,
      'activity_date': activityDate,
      'notes': notes,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // Retrieve activities using pagination.
  Future<List<Map<String, Object?>>> getActivities({
    required int limit,
    required int offset,
  }) async {
    final db = await database;

    return await db.query(
      _tableName,
      orderBy: 'id DESC',
      limit: limit,
      offset: offset,
    );
  }

  // Count all activities.
  Future<int> getActivityCount() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM $_tableName',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Update an existing activity.
  Future<int> updateActivity({
    required int id,
    required String activityName,
    required String activityType,
    required String activityDate,
    required String notes,
  }) async {
    final db = await database;

    return await db.update(
      _tableName,
      {
        'activity_name': activityName,
        'activity_type': activityType,
        'activity_date': activityDate,
        'notes': notes,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete an activity.
  Future<int> deleteActivity(int id) async {
    final db = await database;

    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}