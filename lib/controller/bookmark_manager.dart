import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recipe_app/model/recipe_model.dart';
import 'package:recipe_app/service/bookmark_service.dart';

class BookmarkManager with ChangeNotifier {
  BookmarkManager();
  BookmarkService bookmarkService = BookmarkService();

  Future<List<RecipeModel>> getAllBookmarks() async {
    try {
      await bookmarkService.open();
      List<RecipeModel>? recipies = await bookmarkService.getAllRecipe();
      if (recipies != null) {
        notifyListeners();
        return recipies;
      }
      return [];
    } catch (error) {
      // print('Something went wrong ${error}');
      return [];
    } finally {
      await bookmarkService.close();
    }
  }

  addToBookmark(RecipeModel recipeModel) async {
    try {
      await bookmarkService.open();
      RecipeModel recipe = await bookmarkService.insert(recipeModel);
      //print('Added to bookmark ${recipe.toJson()}');
      await getAllBookmarks();
      toast(msg: "Recipe added bookmarks");
      return recipe;
    } catch (error) {
      // print('Something went wrong ${error}');
    } finally {
      await bookmarkService.close();
    }
  }

  Future<int> removeFromBookmarks(RecipeModel recipeModel) async {
    try {
      await bookmarkService.open();
      int deleteCount = await bookmarkService.delete(recipeModel.id!);
      // print('Removed $deleteCount recipies from bookmark');
      await getAllBookmarks();
      toast(msg: "Recipe removed from bookmark");
      return deleteCount;
    } catch (error) {
      // print('Something went wrong ${error}');
      return 0;
    } finally {
      await bookmarkService.close();
    }
  }

  void toast({required String msg}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }
}
