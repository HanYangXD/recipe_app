import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';


class RecipeInfo extends StatelessWidget {
  String recipeID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Ingredient'),
      ),
      body: Center(child: MyRecipeInfo(this.recipeID)),
      drawer: MyDrawer(),
    );
  }
}


class MyRecipeInfo extends StatelessWidget {
  MyRecipeInfo(String recipeID);

  String recipeID;

  List<Widget> mycards = new List<Widget>();

  void getIngNeeded(String recipeID) async {
    var ingNeeded = await dbHelper.executeQuery(
        'SELECT * FROM ingredientNeeded WHERE recipeID="$recipeID"');
    var rowCount = await dbHelper.executeQuery(
        'SELECT COUNT(*) FROM ingredientNeeded WHERE recipeID="$recipeID"');
    mycards = new List<Widget>();
    for (int i = 0; i < rowCount[0]['COUNT(*)']; i++) {
      mycards.add(IngCard(
          ingNeeded[i]['ingredientName'],
          ingNeeded[i]['ingredientQuantity'].toString(),
          ingNeeded[i]['ingredientUnit']));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
          child: Row(
              children:
              mycards

          )
      ),
    );
  }



}