import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> dbInit() async {
    final folder = await getDatabasesPath();
    return openDatabase(join(folder, 'note.db'), version: 1,
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE notes(id TEXT PRIMARY KEY, title TEXT, subject TEXT, created TEXT, favorite INTEGER)');
    });
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await DBHelper.dbInit();
    db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.dbInit();
    return db.query(table);
  }

  static Future<void> updateData(
      String table, Map<String, dynamic> data) async {
    final db = await DBHelper.dbInit();
    String id = data['id'];
    db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteData(
      String table, Map<String, dynamic> data) async {
    final db = await DBHelper.dbInit();
    String id = data['id'];
    db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
