

import 'package:flutter/material.dart';
import 'package:recipeapp/main.dart';
import 'package:recipeapp/vegetarianRecipe.dart';
import 'package:recipeapp/westernRecipe.dart';

import 'easternRecipe.dart';
import 'manageIngredient.dart';
import 'myIngredientList.dart';

//Future navigateToEastern(context) async {
//  Navigator.push(context, MaterialPageRoute(builder: (context) => Eastern()));
//}

//Future navigateToWestern(context) async {
//  Navigator.push(context, MaterialPageRoute(builder: (context) => Western()));
//}
//
//Future navigateToVegetarian(context) async {
//  Navigator.push(
//      context, MaterialPageRoute(builder: (context) => Vegetarian()));
//}

Future navigateToManageIngredient(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => ManageIngredient()));
}

Future navigateToIngredientList(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => IngredientList()));
}

Future navigateToHome(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => MyApp()));
}