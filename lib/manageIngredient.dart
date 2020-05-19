import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// change `flutter_database` to whatever your project name is
import 'package:recipeapp/database_helper.dart';
import 'main.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class ManageIngredient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Ingredient'),
      ),
      body: Center(child: MyIngredient()),
      drawer: MyDrawer(),
    );
  }
}

class MyIngredient extends StatefulWidget {
  @override
  MyIngredientState createState() => MyIngredientState();
}

class MyIngredientState extends State<MyIngredient> {
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;
  final ingredientController = TextEditingController();
  final quantityController = TextEditingController();
  final unitController = TextEditingController();
  final dateController = TextEditingController();

  //String a = '11';
  List<String> unitDDL = [
    'Unit',
    'Gram',
  ];
  String dropdownValue = 'Gram';
  String holder = '';

  void getDropDownItem() {
    setState(() {
      holder = dropdownValue;
    });
  }

  // homepage layout

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    ingredientController.dispose();
    quantityController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            //obscureText: true,

            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ingredient',
            ),
            controller: ingredientController,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  //obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Quantity',
                  ),
                  keyboardType: TextInputType.number,
                  controller: quantityController,
                ),
              ),
              Expanded(
                  child: DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String data) {
                  setState(() {
                    dropdownValue = data;
                  });
                },
                items: unitDDL.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ))
            ],
          ),
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                //print('haha');
                var currentDate = new DateTime.now();
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: currentDate, onConfirm: (date) {
                  dateController.text = date.toString().substring(0, 10);

//                  print('confirm $date');
                }, currentTime: DateTime.now(), locale: LocaleType.en);
              },
              child: TextField(
                controller: dateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Date',
                  enabled: false,
                ),
              )),
          RaisedButton(
            child: Text(
              'Add Item!',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
//              _insert();
              insertIngredient();
              setState(() {
                FocusScope.of(context).requestFocus(FocusNode());
              });
            },
          ),

        ],
      ),
    ]));
  }

  // Button onPressed methods

  void insertIngredient() async {
    String ingName = ingredientController.text;
    String ingQuantity = quantityController.text;
    String ingUnit = dropdownValue;
    String ingExpiry = dateController.text;
    String query =
        'INSERT INTO ingredient (ingName, ingQuantity, ingUnit, ingExpiry) VALUES ("$ingName", "$ingQuantity","$ingUnit","$ingExpiry");';
    toast('Added Successfully!');
    //toast(query);
    dbHelper.insertIngredient(query);
  }

//not in used anymore
  void _insert() async {
    // row to insert
    Map<String, dynamic> ingredientRow = {
      DatabaseHelper.ingredientID: 5,
      DatabaseHelper.ingredientName: ingredientController.text,
      DatabaseHelper.ingredientQuantity: quantityController.text,
      DatabaseHelper.ingredientUnit: unitController.text,
      DatabaseHelper.ingredientExpiry: dateController.text,
    };

    final id = await dbHelper.insert(ingredientRow);
    toast('Yay! inserted row id: $id!');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

//  void _update() async {
//    // row to update
//    Map<String, dynamic> row = {
//      DatabaseHelper.columnId: 1,
//      DatabaseHelper.columnName: 'Mary',
//      DatabaseHelper.columnAge: 32
//    };
//    final rowsAffected = await dbHelper.update(row);
//    print('updated $rowsAffected row(s)');
//  }
//
  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
}

void toast(String msgs) {
  Fluttertoast.showToast(
    msg: msgs,
    toastLength: Toast.LENGTH_LONG,
  );
}
