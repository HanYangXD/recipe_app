import 'package:flutter/material.dart';
import 'package:recipeapp/database_helper.dart';
import 'main.dart';
import 'database_helper.dart';

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



class MyIngredientList extends StatefulWidget {
  @override
  MyIngredientListState createState() => MyIngredientListState();
}


final dbHelper = DatabaseHelper.instance;

class MyIngredientListState extends State<MyIngredientList> {
  @override
  void initState() {
    fetchIngToCard();
    super.initState();
  }

  List<Widget> mycards = new List<Widget>();
  var allIngredient;

  void fetchIngToCard() async {
    allIngredient = await dbHelper.getAllIngredient();

    //print(allIngredient);
//  String rowCount =  dbHelper.queryRowCount().toString();
    var rowCount = await dbHelper.executeQuery('SELECT COUNT(*) FROM ingredient');
    //print(rowCount);
    //print(rowCount[0]['COUNT(*)']);

    mycards = new List<Widget>();
    for (int i = 0; i < rowCount[0]['COUNT(*)']; i++) {
      mycards.add(MyCardIngList(
          allIngredient[i]['ingID'],
          allIngredient[i]['ingName'],
          allIngredient[i]['ingQuantity'].toString(),
          allIngredient[i]['ingUnit'],
          allIngredient[i]['ingExpiry']));
    }
    this.setState(() { });
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
