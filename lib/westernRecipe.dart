import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart';
import 'package:recipeapp/main.dart';

class Western extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Recipe App',
        home: Scaffold(
            appBar: AppBar(
              title: Text('Western Cuisine'),
            ),
            body: Center(child: RecipeList()),
            drawer: MyDrawer()));
  }
}

class RecipeList extends StatefulWidget {
  @override
  RecipeListState createState() => RecipeListState();
}

class RecipeListState extends State<RecipeList> {
  List<Widget> mycards = new List<Widget>();
  int buttonName = 1;

  @override
  void initState() {
    // TODO: query from db
    // append into mycards

    for (int counter = 0; counter < 3; counter++) {
      mycards.add(MyCard());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    for (int counter = 0; counter < 3; counter ++) {
//      mycards.add(MyCard());
//    }
    return ListView(
        padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
        children: mycards);
  }
}