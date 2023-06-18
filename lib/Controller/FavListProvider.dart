import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:yusr/Model/RecipeModel.dart';

class FavListProvider with ChangeNotifier {
  addFavListData({
    required String? FavListId,
    required String FavListName,
    required String FavListImage,
    String? FavListDescription,
    String? FavListCallories,
    String? FavListIngredients,
    String? FavListTime,
    String? FavListPersons,
  }) {
    FirebaseFirestore.instance
        .collection("FavList")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("FavRecipeList")
        .doc(FavListId)
        .set({
      "favRecipeListId": FavListId,
      "favRecipeListName": FavListName,
      "favRecipeListImage": FavListImage,
      "favRecipeListDescription": FavListDescription,
      "favRecipeListCallories": FavListCallories,
      "favRecipeIngredients": FavListIngredients,
      "favRecipeListTime": FavListTime,
      "favRecipeListPersons": FavListPersons,
      //"favList": true,
    });
  }

///// Get WishList Data ///////
  List<Recipe> favRecipeList = [];

  getFavListData() async {
    List<Recipe> newList = [];
    QuerySnapshot value = await FirebaseFirestore.instance
        .collection("FavList")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("FavRecipesList")
        .get();
    value.docs.forEach(
      (element) {
        Recipe RecipeModel = Recipe(
          RecipeID: element.get("favRecipeListId"),
          RecipePhoto: element.get("favRecipeListImage"),
          RecipeName: element.get("favRecipeListName"),
          description: element.get("favRecipeListDescription"),
          callories: element.get("favRecipeListCallories"),
          ingredients: element.get("favRecipeIngredients"),
          time: element.get("favRecipeListTime"),
          persons: element.get("favRecipeListPersons"),
        );
        newList.add(RecipeModel);
        print(newList);
      },
    );
    await (favRecipeList = newList);
    //print(favRecipeList.length);
    notifyListeners();
  }

  List<Recipe> get getFavList {
    return favRecipeList;
  }

////////// Delete WishList /////
  deleteFavList(favRecipeListId) {
    FirebaseFirestore.instance
        .collection("FavList")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("FavRecipesList")
        .doc(favRecipeListId)
        .delete();
  }
}
