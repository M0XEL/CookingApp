import 'package:cloud_firestore/cloud_firestore.dart';

addUserToGroup(DocumentSnapshot user, DocumentSnapshot group) {

  /// update firestore document in groups collection with new user id
  Firestore.instance.runTransaction((transaction) async {
    DocumentSnapshot freshGroupSnapshot = await transaction.get(group.reference);
    List<String> memberIds = List<String>();
    memberIds.addAll(freshGroupSnapshot['memberIds'].cast<String>());
    if (memberIds.any((id) => id == user.documentID)) {
      transaction.update(group.reference, {'memberIds': memberIds});
    }
    else {
      memberIds.add(user.documentID);
      transaction.update(group.reference, {'memberIds': memberIds});
    }
  });

  /// update firestore document in users collection with new group id
  Firestore.instance.runTransaction((transaction) async {
    DocumentSnapshot freshUserSnapshot = await transaction.get(user.reference);
    List<String> groupIds = List<String>();
    groupIds.addAll(freshUserSnapshot['groupIds'].cast<String>());
    if (groupIds.any((id) => id == group.documentID)) {
      transaction.update(user.reference, {'groupIds': groupIds});
    }
    else {
      groupIds.add(group.documentID);
      transaction.update(user.reference, {'groupIds': groupIds});
    }
  });
}