import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/info_item.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'info.db');

    return await openDatabase(
      path,
      version: 4,  // version change for meta_data table
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE info_items(
            id TEXT PRIMARY KEY,
            name TEXT,
            picture TEXT,
            imageUrl TEXT,
            bloodType TEXT,
            type TEXT,
            description TEXT,
            phoneNumber TEXT,
            googleMapLocation TEXT,
            createdAt TEXT,
            tableName TEXT
          )
        ''');

        // NEW TABLE for storing last update time
        await db.execute('''
          CREATE TABLE meta_data(
            key TEXT PRIMARY KEY,
            value TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE info_items ADD COLUMN type TEXT');
        }
        if (oldVersion < 4) {
          await db.execute('''
            CREATE TABLE meta_data(
              key TEXT PRIMARY KEY,
              value TEXT
            )
          ''');
        }
      },
    );
  }

  // -------------------------------------------------------------
  // INSERT ITEMS
  // -------------------------------------------------------------
  Future<void> insertItem(InfoItem item, String tableName) async {
    final db = await database;
    await db.insert(
      'info_items',
      item.toMap(tableName),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // -------------------------------------------------------------
  // GET ITEMS
  // -------------------------------------------------------------
  Future<List<InfoItem>> getItems(String tableName) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'info_items',
      where: 'tableName = ?',
      whereArgs: [tableName],
    );

    return List.generate(maps.length, (i) {
      return InfoItem.fromMap(maps[i]);
    });
  }

  // -------------------------------------------------------------
  // CLEAR ITEMS
  // -------------------------------------------------------------
  Future<void> clearItems(String tableName) async {
    final db = await database;
    await db.delete(
      'info_items',
      where: 'tableName = ?',
      whereArgs: [tableName],
    );
  }

  // -------------------------------------------------------------
  // SAVE LAST UPDATE TIME (NEW)
  // -------------------------------------------------------------
  Future<void> saveLastUpdateTime() async {
    final db = await database;
    await db.insert(
      'meta_data',
      {
        'key': 'last_update',
        'value': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // -------------------------------------------------------------
  // GET LAST UPDATE TIME (NEW)
  // -------------------------------------------------------------
  Future<DateTime?> getLastUpdateTime() async {
    final db = await database;
    final result = await db.query(
      'meta_data',
      where: 'key = ?',
      whereArgs: ['last_update'],
    );

    if (result.isEmpty) return null;
    return DateTime.tryParse(result.first['value'] as String);
  }
}
