import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDB {
  Database? _db;

  Future<Database> get database async {
    _db ??= await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'app.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE cart ('
      'product_id INTEGER PRIMARY KEY, '
      'product_json TEXT NOT NULL, '
      'quantity INTEGER NOT NULL'
      ')',
    );
  }
}
