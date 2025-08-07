import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteService {
  String _dbPath;
  Database? _db;
  SqliteService([this._dbPath = 'data.db']);

  Future<Database> get db async {
    if (_db == null) {
      _db = await openDb();
    }
    return _db!;
  }

  Future<Database> openDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _dbPath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notifs (
            idNotif INTEGER PRIMARY KEY AUTOINCREMENT, 
            idGame TEXT, 
            title TEXT,
            content TEXT,
            date TEXT,
            type TEXT,
            created_at TEXT, 
            updated_at TEXT
          )
        ''');
      },
    );
  }
}
