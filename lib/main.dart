// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:ui';
import 'dart:async';
import 'package:path/path.dart';
import 'package:recipeapp/vegetarianRecipe.dart';
import 'package:recipeapp/westernRecipe.dart';
import 'package:sqflite/sqflite.dart';
import 'easternRecipe.dart';
import 'westernRecipe.dart';
import 'vegetarianRecipe.dart';
import 'package:path_provider/path_provider.dart';
import 'manageIngredient.dart';

import 'manageIngredient.dart';
import 'database_helper.dart';
import 'myIngredientList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Recipe App',
        home: Scaffold(
            appBar: AppBar(
              title: Text('Recipes'),
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
      mycards.add(MyCard(counter: counter));
    }
    //var ingredients = dbHelper.getAllIngredient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    for (int counter = 0; counter < 3; counter ++) {
//      mycards.add(MyCard());
//    }
    return ListView(
        padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0), children: mycards);
  }
}

class MyCard extends StatelessWidget {
  final wordPair = WordPair.random();
  int counter = 0;

  MyCard({this.counter});

  String serving;

  //String foodName = getFoodName();
  //var ingredients = dbHelper.getAllIngredient();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlue,
      child: ListTile(
        title: Container(
            child: Row(children: [
          Text('Image'),
          Column(children: [
            Text(wordPair.toString()),
            Container(
                child: Column(children: [
              Row(children: [
                Text('Serving: $serving'),
//                Text('Tag 2'),
              ]),
            ]))
          ]),
          Text('Time needed: '),
        ])),
        onTap: () {
          print('aa');
        },
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: Text('Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              )),
          ListTile(
              title: Text('Eastern Cuisine'),
              onTap: () {
                navigateToEastern(context);
                print('eastern meal');
              }),
          ListTile(
              title: Text('Western Cuisine'),
              onTap: () {
                navigateToWestern(context);
                print('western meal');
              }),
          ListTile(
              title: Text('Vegetarian'),
              onTap: () {
                navigateToVegetarian(context);
                print('vegetarian meal');
              }),
          ListTile(
              title: Text('Add Ingredient'),
              onTap: () {
                //                print('vegetarian meal');
                navigateToManageIngredient(context);
              }),
          ListTile(
              title: Text('Ingredient List'),
              onTap: () {
                navigateToIngredientList(context);
//                print('vegetarian meal');
              }),
          //ListTile(title: Text('Item 2'), onTap: () {}),
        ],
      ),
    );
  }
}

Future navigateToEastern(context) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Eastern()));
}

Future navigateToWestern(context) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Western()));
}

Future navigateToVegetarian(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => Vegetarian()));
}

Future navigateToManageIngredient(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => ManageIngredient()));
}

Future navigateToIngredientList(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => IngredientList()));
}

class MyCardLoop extends StatelessWidget {
  //final wordPair = WordPair.random();

  String foodName, serving, timeNeeded;

  MyCardLoop([this.foodName, this.serving, this.timeNeeded]);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlue,
      child: ListTile(
        title: Container(
            child: Row(children: [
          Text('Image'),
          Column(children: [
            //Text(wordPair.toString()),
            Container(
                child: Column(children: [
              Text('Food Name: $serving'),
              Row(children: [
                Text('Serving: $serving'),
//                Text('Tag 2'),
              ]),
            ]))
          ]),
          Text('Time needed: '),
        ])),
        onTap: () {
          print('aa');
        },
      ),
    );
  }
}

class MyCardIngList extends StatelessWidget {
  //final wordPair = WordPair.random();

  String ingName, ingUnit, ingExpiry;
  int ingID;
  String ingQuantity;

  final ingredientController = TextEditingController();
  final quantityController = TextEditingController();
  final unitController = TextEditingController();
  final dateController = TextEditingController();

  MyCardIngList(
      [this.ingID,
      this.ingName,
      this.ingQuantity,
      this.ingUnit,
      this.ingExpiry]);

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
                    new TextField(
                      controller: quantityController,
                      decoration: new InputDecoration(
                          hintText: "Quantity: " + this.ingQuantity),
                    ),
                    new TextField(
                      controller: unitController,
                      decoration: new InputDecoration(
                          hintText: "Unit: " + this.ingUnit),
                    ),
                    new TextField(
                      controller: dateController,
                      decoration: new InputDecoration(
                          hintText: "Date: " + this.ingExpiry),
                    ),
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
