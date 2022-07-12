import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'car.dart';

class DatabaseHelper {
  static const _databaseName = "cardb.db";
  static const _dataVersion = 1;

  static const table = "cars_table";

  static const columnId = "id";
  static const columnName = 'name';
  static const columnMiles = 'miles';

  //We create the singlenton class which allow us
  //To have only a single local storage.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  //Only have a single app-wide reference to the database
  static late Database _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    print(path.toString());
    return await openDatabase(path, version: _dataVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $table ($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnName TEXT NOT NULL, $columnMiles INTEGER NOT NULL)');
  }

  //The value returned is the id
  Future<int> insert(Car car) async {
    Database db = await instance.database;
    return await db.insert(table, {'name': car.name, 'miles': car.miles});
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryRows(rowName) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnName LIKE '%name%'");
  }

  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM $table"));
  }

  Future<int> update(Car car) async {
    Database db = await instance.database;
    int id = car.toMap()['id'];
    return await db
        .update(table, car.toMap(), where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
