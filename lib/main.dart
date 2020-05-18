// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'database_helper.dart';
import 'pageLinks.dart';

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

    for (int counter = 0; counter < 60; counter++) {
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
      child: Container(
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
