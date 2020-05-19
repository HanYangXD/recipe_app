// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'database_helper.dart';
import 'pageLinks.dart';
import 'GlobalDef.dart';

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

final dbHelper = DatabaseHelper.instance;

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
    fetchRecipeToCard();
//    for (int counter = 0; counter < 60; counter++) {
//      mycards.add(MyCard(this.deleteCallBack("0")));
//    }
    //var ingredients = dbHelper.getAllIngredient();
    super.initState();
  }

  void deleteCallBack(String id) {
    //id =
    setState(() {
      // re-fetch card from database
      fetchRecipeToCard();
    });
  }

  List<Widget> recipeListCard = new List<Widget>();
  var allRecipe;

  void fetchRecipeToCard() async {
//    String query = 'INSERT INTO recipe values (1, "Fried Rice", "cook rice, let it cold, put oil, heat, fry, season, done", "/imgpath.png", 30, 5)';
//    dbHelper.executeQuery(query);
    allRecipe = await dbHelper.getAllRecipe();
    var rowCount = await dbHelper.executeQuery('SELECT COUNT(*) FROM recipe');

    recipeListCard = new List<Widget>();
    for (int i = 0; i < rowCount[0]['COUNT(*)']; i++) {
      recipeListCard.add(MyCard(
          deleteCallBack,
          allRecipe[i]['recipeID'].toString(),
          allRecipe[i]['recipeName'],
          allRecipe[i]['stepsNeeded'],
          allRecipe[i]['imgPath'],
          allRecipe[i]['timeNeeded'].toString(),
          allRecipe[i]['serving'].toString()));
      print(allRecipe[i]['recipeID']);
    }

    this.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
        children: recipeListCard);
  }
}

class MyCard extends StatelessWidget {
  final wordPair = WordPair.random();
  final DeleteCallBack deleteCallBack;
  int counter = 0;

  String recipeID, recipeName, steps, imgpath, time, serving;

  MyCard(this.deleteCallBack,
      [this.recipeID,
      this.recipeName,
      this.steps,
      this.imgpath,
      this.time,
      this.serving]);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlue,
      child: Container(
          height: 50,
          child: Row(children: [
            //Text('Image'),
            Image.network('https://picsum.photos/250?image=9'),
            Column(children: [
              Text(this.recipeName + this.recipeID),
              Container(
                  child: Column(children: [
                Row(children: [
                  Text('Serving: ' + this.serving),
//                Text('Tag 2'),
                ]),
              ]))
            ]),
            Text('Time needed: ' + this.time),
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
            ),
          ),
          ListTile(
              title: Text('Home'),
              onTap: () {
//                navigateToEastern(context);
                navigateToHome(context);
                print('eastern meal');
              }),
          ListTile(
              title: Text('Eastern Cuisine'),
              onTap: () {
//                navigateToEastern(context);
                print('eastern meal');
              }),
          ListTile(
              title: Text('Western Cuisine'),
              onTap: () {
//                navigateToWestern(context);
                print('western meal');
              }),
          ListTile(
              title: Text('Vegetarian'),
              onTap: () {
//                navigateToVegetarian(context);
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
