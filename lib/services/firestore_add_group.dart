import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

Future<DocumentReference> addGroup(DocumentSnapshot user) async {

    /// create document in groups collection
    DocumentReference groupReference = await Firestore.instance.collection('groups').add({'name': '-'});
    await Firestore.instance.runTransaction((transaction) async {
      transaction.set(groupReference, {
        'name': 'Neue Gruppe',
        'memberIds': [user.documentID],
      });
    });

    /// update document in users collection with new group id
    await Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshUserSnapshot = await transaction.get(user.reference);
      List<String> groupIds = List<String>();
      groupIds.addAll(freshUserSnapshot['groupIds'] != null ? freshUserSnapshot['groupIds'].cast<String>() : []);
      groupIds.add(groupReference.documentID);
      transaction.update(user.reference, {'groupIds': groupIds});
    });

    /// await to return valid reference
    return groupReference;
  }