import 'package:cloud_firestore/cloud_firestore.dart';

vote(DocumentReference votingReference, String recipeId) {
//Firestore.instance.collection('recipe_votes').document(groups[index].documentID).collection('deadlines').document('today').get().then((document) {
  Firestore.instance.runTransaction((transaction) async {
    DocumentSnapshot freshSnapshot = await transaction.get(votingReference);
    //List<String> votes = List<String>();
    //votes.addAll(freshSnapshot['hasVoted'].cast<String>());
    /*if (votes.contains(user.data.uid)) {
      transaction.update(snapshot.data.reference, {'hasVoted': votes});
    }
    else {*/
      Map<String, int> recipes = Map<String, int>();
      recipes.addAll(freshSnapshot['recipes'] != null ? freshSnapshot['recipes'].cast<String, int>() : []);
      recipes.update(recipeId, (votes) => ++votes);
      transaction.update(votingReference, {'recipes': recipes});
      //votes.add(user.uid);
      //transaction.update(snapshot.data.reference, {'hasVoted': votes});
    //}
  });
//}),
}