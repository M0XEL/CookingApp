import 'package:cloud_firestore/cloud_firestore.dart';

addRecipeToGroup(String recipeId, DocumentSnapshot group) => Firestore.instance.collection('recipe_votes').document(group.documentID).collection('deadlines').document('today').get().then((document) {
  if (document.exists) {
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnapshot = await transaction.get(document.reference);
      Map<String, int> recipes = Map<String, int>();
      recipes.addAll(freshSnapshot['recipes'] != null ? freshSnapshot['recipes'].cast<String, int>() : []);
      print(recipes);
      if (recipes.containsKey(recipeId)) {
        transaction.update(document.reference, {'recipes': recipes});
      }
      else {
        List<MapEntry<String, int>> l = List<MapEntry<String, int>>();
        l.add(MapEntry(recipeId, 0));
        recipes.addEntries(l);
        transaction.update(document.reference, {'recipes': recipes});
      }
    });
  }
  else {
    Firestore.instance.runTransaction((transaction) async {
      Map<String, int> recipes = Map<String, int>();
      List<MapEntry<String, int>> l = List<MapEntry<String, int>>();
      l.add(MapEntry(recipeId, 0));
      recipes.addEntries(l);
      transaction.set(document.reference, {'recipes': recipes});
    });
  }
});