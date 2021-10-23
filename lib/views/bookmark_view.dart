import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controller/bookmark_manager.dart';
import 'package:recipe_app/controller/recipe_manager.dart';
import 'package:recipe_app/model/recipe_model.dart';
import 'package:recipe_app/views/detail_view_example.dart';

//TODO: GET ALL BOOKMARKED RECIPES
//TODO: DELETE RECIPE

class BookmarkView extends StatelessWidget {
  const BookmarkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookmarkManager>(
      create: (context) => BookmarkManager(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Bookmark'),
          ),
          body:
              Consumer<BookmarkManager>(builder: (context, bookManager, child) {
            return FutureBuilder(
                future: bookManager.getAllBookmarks(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<RecipeModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        RecipeModel recipeModel = snapshot.data![index];
                        return ListTile(
                          title: Text(recipeModel.title),
                          subtitle: Text(recipeModel.category),
                          trailing: IconButton(
                              onPressed: () async {
                                await bookManager
                                    .removeFromBookmarks(recipeModel);
                              },
                              icon: const Icon(Icons.delete)),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: snapshot.data!.length);
                });
          })),
    );
  }
}
