import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'database_helper.dart';
import 'main.dart';
import 'manageIngredient.dart';
import 'GlobalDef.dart';

class IngredientList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Ingredient'),
      ),
      body: Center(child: MyIngredientList()),
      drawer: MyDrawer(),
    );
  }
}

final dbHelper = DatabaseHelper.instance;

class MyIngredientList extends StatefulWidget {
  @override
  MyIngredientListState createState() => MyIngredientListState();
}

class MyIngredientListState extends State<MyIngredientList> {
  @override
  void initState() {
    fetchIngToCard();
    super.initState();
  }

  void deleteCallBack(String id) {
    //id =
    setState(() {
      // re-fetch card from database
      fetchIngToCard();
    });
  }

  List<Widget> mycards = new List<Widget>();
  var allIngredient;

  void fetchIngToCard() async {
    allIngredient = await dbHelper.getAllIngredient();


    //print(allIngredient);
//  String rowCount =  dbHelper.queryRowCount().toString();
    var rowCount =
        await dbHelper.executeQuery('SELECT COUNT(*) FROM ingredient');
    //print(rowCount);
    //print(rowCount[0]['COUNT(*)']);

    mycards = new List<Widget>();
    for (int i = 0; i < rowCount[0]['COUNT(*)']; i++) {
      mycards.add(MyCardIngList(deleteCallBack,
          allIngredient[i]['ingID'],
          allIngredient[i]['ingName'],
          allIngredient[i]['ingQuantity'].toString(),
          allIngredient[i]['ingUnit'],
          allIngredient[i]['ingExpiry']));
    }
    this.setState(() {});
  }

  Widget build(BuildContext context) {
//    var allIngredient = await dbHelper.getAllIngredient();

//    print(allIngredient);

    return Center(
        child: ListView(
            children:
                // MyCardLoop(),
                mycards

            // child: Text('img')
            ));
  }
}

//cards for ingredient Lists
class MyCardIngList extends StatelessWidget {

  //final wordPair = WordPair.random();

  String ingName, ingUnit, ingExpiry;
  int ingID;
  String ingQuantity;

  final ingredientController = TextEditingController();
  final quantityController = TextEditingController();
  final unitController = TextEditingController();
  final dateController = TextEditingController();

  final DeleteCallBack deleteCallBack;

  MyCardIngList(this.deleteCallBack,
      [this.ingID,
      this.ingName,
      this.ingQuantity,
      this.ingUnit,
      this.ingExpiry]
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlue,
      child: ListTile(
        title: Container(
            child: Row(children: [
          Text('Name: ' + this.ingName),
          Column(children: [
            Text('Quantity: ' +
                this.ingQuantity.toString() +
                ' ' +
                this.ingUnit),
            Text('Expiry: ' + this.ingExpiry),
          ]),
        ])),
        onTap: () {
          //print('ID: ' + this.ingID.toString());
          toast('ID: ' + this.ingID.toString());
          showDialog(
              child: new Dialog(
                child: new Column(
                  children: <Widget>[
                    new TextField(
                      controller: ingredientController,
                      decoration: new InputDecoration(
                          hintText: 'Name: ' + this.ingName),
                    ),
//                    new TextField(
//                      controller: quantityController,
//                      decoration: new InputDecoration(
//                          hintText: "Quantity: " + this.ingQuantity),
//                    ),
                    TextField(
                      //obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Quantity',
                      ),
                      keyboardType: TextInputType.number,
                      controller: quantityController,
                    ),

                    new TextField(
                      controller: unitController,
                      decoration: new InputDecoration(
                          hintText: "Unit: " + this.ingUnit),
                    ),
//                    new TextField(
//                      controller: dateController,
//                      decoration: new InputDecoration(
//                          hintText: "Date: " + this.ingExpiry),
//                    ),

                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          //print('haha');
                          var currentDate = new DateTime.now();
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: currentDate, onConfirm: (date) {
                            dateController.text =
                                date.toString().substring(0, 10);

//                  print('confirm $date');
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        child: TextField(
                          controller: dateController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Date',
                            enabled: false,
                          ),
                        )),

                    new FlatButton(
                      child: new Text("Update"),
                      onPressed: () {
                        String query = 'UPDATE INGREDIENT SET ingName="' +
                            ingredientController.text +
                            '", ingQuantity="' +
                            quantityController.text +
                            '", ingUnit="' +
                            unitController.text +
                            '", ingExpiry="' +
                            dateController.text +
                            '" WHERE ingID="' +
                            this.ingID.toString() +
                            '";';
                        dbHelper.executeQuery(query);
                        print(query);

                        Navigator.pop(context);
                      },
                    ),
                    new FlatButton(
                        child: new Text("Detele"),
                        onPressed: () {
                          String query = 'DELETE FROM INGREDIENT WHERE ingID=' +
                              (this.ingID).toString();
                          dbHelper.executeQuery(query);
                          //setState(() {});
                          deleteCallBack("!");
                          Navigator.pop(context);
                        })
                  ],
                ),
              ),
              context: context);
        },
      ),
    );
  }
}
