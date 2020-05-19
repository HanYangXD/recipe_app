// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'database_helper.dart';
import 'manageIngredient.dart';
import 'pageLinks.dart';
import 'GlobalDef.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
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

var ingNeeded;
final dbHelper = DatabaseHelper.instance;

class RecipeList extends StatefulWidget {
  @override
  RecipeListState createState() => RecipeListState();
}

class RecipeListState extends State<RecipeList> {
  //List<Widget> mycards = new List<Widget>();
  int buttonName = 1;

  @override
  void initState() {
    // TODO: query from db
    fetchRecipeToCard();
    super.initState();
  }

  void deleteCallBack(String id) {
    setState(() {
      // re-fetch card from database
      fetchRecipeToCard();
    });
  }

  List<Widget> recipeListCard = new List<Widget>();
  var allRecipe, showRecipe;

  void fetchRecipeToCard() async {
//    String query = 'INSERT INTO recipe values (1, "Fried Rice", "cook rice, let it cold, put oil, heat, fry, season, done", "/imgpath.png", 30, 5)';
//    dbHelper.executeQuery(query);
    allRecipe = await dbHelper.getAllRecipe();
    showRecipe = allRecipe;
    var rowCount = await dbHelper.executeQuery('SELECT COUNT(*) FROM recipe');

    this.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    recipeListCard = new List<Widget>();
    for (int i = 0; i < showRecipe.length; i++) {
      recipeListCard.add(MyHomeRecipeList(
          deleteCallBack,
          showRecipe[i]['recipeID'].toString(),
          showRecipe[i]['recipeName'],
          showRecipe[i]['stepsNeeded'],
          showRecipe[i]['imgPath'],
          showRecipe[i]['timeNeeded'].toString(),
          showRecipe[i]['serving'].toString()));
    }

    recipeListCard.insert(0, _searchBar());

    return ListView(
        padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
        children: recipeListCard);
  }

  Widget _searchBar() {
    TextEditingController searchController = TextEditingController();
    return Row(
      children: <Widget>[
        Expanded(
            child: TextField(
          controller: searchController,
        )),
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(
                () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  var temp = new List<Map>();
                  showRecipe = allRecipe;
                  for (var r in showRecipe) {
                    if (r["recipeName"]
                            .toString()
                            .toLowerCase()
                            .indexOf(searchController.text) !=
                        -1) {
                      temp.add(r);
                    }
                  }

                  showRecipe = temp;
                },
              );
            }),
        IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              setState(
                () {
                  showRecipe = allRecipe;
                },
              );
            })
      ],
    );
  }
}

class SearchBar extends StatefulWidget {
  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: TextField()),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        )
      ],
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

class MyHomeRecipeList extends StatelessWidget {
  final wordPair = WordPair.random();
  final DeleteCallBack deleteCallBack;

  int counter = 0;

  String recipeID, recipeName, steps, imgpath, time, serving;
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
      //print(ingNeeded[i]['recipeID'].toString() + ingNeeded[i]['ingredientName']);
    }
  }

  MyHomeRecipeList(this.deleteCallBack,
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
        child: ListTile(
            title: Container(
                height: 250,
                child: Column(children: [
                  //Text('Image'),
                  Image.network(
                    this.imgpath,
//                    width: 50,
//                    height: 35,
                    fit: BoxFit.fitWidth,
                  ),
                  Text(this.recipeName + this.recipeID),
                  Text('Serving: ' + this.serving),
                  Text('Time: ' + this.time + '\n\t\t\t\t\t\t\t\t\t\tMins'),
                ])),
            onTap: () {
              toast(this.recipeID);
              getIngNeeded(this.recipeID);
              showDialog(
                  child: ListView(children: [
                    new Dialog(
                      child: new Column(
                        children: [
                          Image.network(
                            this.imgpath,
                          ),
                          Text(
                            this.recipeName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Center(
                            child: Row(children: [
                              Column(
                                  children: mycards,
                                  mainAxisAlignment: MainAxisAlignment.center),
                            ]),
                          ),
                          Card(
                              child: Column(
                            children: <Widget>[
                              new Text(this.steps),
                            ],
                          )),
                          new FlatButton(
                              child: new Text("Detele"),
                              onPressed: () {
                                deleteCallBack("0");
                                Navigator.pop(context);
                              })
                        ],
                      ),
                    )
                  ]),
                  context: context);
            }));
  }
}

class IngCard extends StatelessWidget {
  String ingName, ingQuantity, ingUnit;

  IngCard([this.ingName, this.ingQuantity, this.ingUnit]);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlue,
      child: Align(
        alignment: Alignment.center,
        child: Text(this.ingName + " " + this.ingQuantity + " " + this.ingUnit),
      ),
    );
  }
}
