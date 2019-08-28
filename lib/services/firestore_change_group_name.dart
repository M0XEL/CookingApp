import 'package:cloud_firestore/cloud_firestore.dart';

changeGroupName(DocumentReference groupReference, String newName) {
  Firestore.instance.runTransaction((transaction) async {
    DocumentSnapshot freshSnapshot = await transaction.get(groupReference);
    freshSnapshot.data['name'] = newName;
    transaction.update(groupReference, freshSnapshot.data);
  });
}
