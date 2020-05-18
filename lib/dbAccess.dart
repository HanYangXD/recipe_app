import 'package:flutter/cupertino.dart';
import 'package:recipeapp/database_helper.dart';
import 'main.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


final dbHelper = DatabaseHelper.instance;

//Future<List<Map<String, dynamic>>> queryWhere(String table, String where) async {
//  Database db = await instance.database;
//  return await db.query(table, where: where);
//}

class aa extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    throw UnimplementedError();
  }
//  void _query() async {
//    List<Map> result = await dbHelper.rawQuery('SELECT * FROM my_table WHERE name=?', ['Mary']);
//    print('query all rows:');
//    result.forEach((row) => print(row)
//    );
//  }
}

String getServing(int counter){
  dbHelper.queryWhere('ingredient', 'ingredientID=$counter');
}

//String getAll(int counter){
////  dbHelper.
//  List<Map> result = await dbHelper.rawQuery('SELECT * FROM my_table WHERE name=?', ['Mary']);
//}

