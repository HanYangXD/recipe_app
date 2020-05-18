
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'main.dart';
import 'manageIngredient.dart';

class DatabaseHelper {

  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'ingredient';

  static final ingredientID     = 'ingID';
  static final ingredientName   = 'ingName';
  static final ingredientQuantity = 'ingQuantity';
  static final ingredientUnit = 'ingUnit';
  static final ingredientExpiry = 'ingExpiry';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $ingredientID INTEGER AUTOINCREMENT PRIMARY KEY,
            $ingredientName TEXT NOT NULL,
            $ingredientQuantity DOUBLE NOT NULL,
            $ingredientUnit TEXT NOT NULL,
            $ingredientExpiry DATE NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }



  Future<List<Map<String, dynamic>>> queryWhere(String table, String where) async {
    Database db = await instance.database;
    return await db.query(table, where: where);
  }


  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<List> executeQuery(String query) async {
    Database db = await instance.database;
    var result = await db.rawQuery(query);
    //print(result);
    return result;
  }

  Future<List> getAllIngredient() async {
    Database db = await instance.database;
    var result = await db.rawQuery('SELECT * FROM ingredient');

//    print(result);
//    print((result[0]["ingID"]));

//    if (result[0].containsKey("ingID")) {
//      print(result[0]["ingID"]);
//    }


    return result;
  }


  Future<List> insertIngredient(String query) async {
    Database db = await instance.database;
    var result = await db.rawQuery(query);

//    print(result);
//    print((result[0]["ingID"]));

//    if (result[0].containsKey("ingID")) {
//      print(result[0]["ingID"]);
//    }


    return result;
  }




//  createCustomer(Customer customer) async {
//    var result = await database.rawInsert(
//        "INSERT INTO Customer (id,first_name, last_name, email)"
//            " VALUES (${customer.id},${customer.firstName},${customer.lastName},${customer.email})");
//    return result;
//  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
//  Future<int> update(Map<String, dynamic> row) async {
//    Database db = await instance.database;
//    int id = row[columnId];
//    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
//  }
//
//  // Deletes the row specified by the id. The number of affected rows is
//  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$ingredientID = ?', whereArgs: [id]);
  }
}
