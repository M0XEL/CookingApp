import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

removeUserFromGroup(DocumentSnapshot member, DocumentSnapshot group, BuildContext context) {
  Firestore.instance.runTransaction((transaction) async {
    DocumentSnapshot freshUserSnapshot = await transaction.get(member.reference);
    List<String> groupIds = List<String>();
    groupIds.addAll(freshUserSnapshot['groupIds'].cast<String>());
    if (groupIds.any((id) => id == group.documentID)) {
      groupIds.removeWhere((id) => id == group.documentID);
      transaction.update(member.reference, {'groupIds': groupIds});
    }
    else {
      transaction.update(member.reference, {'groupIds': groupIds});
    }
  });
  Firestore.instance.runTransaction((transaction) async {
    DocumentSnapshot freshGroupSnapshot = await transaction.get(group.reference);
    List<String> memberIds = List<String>();
    memberIds.addAll(freshGroupSnapshot['memberIds'].cast<String>());
    if (memberIds.any((id) => id == member.documentID)) {
      memberIds.removeWhere((id) => id == member.documentID);
      if (memberIds.isEmpty) {
        transaction.delete(group.reference); // ADD Popup: Gruppe wirklich löschen
        Navigator.pop(context);
      }
      else {
        transaction.update(group.reference, {'memberIds': memberIds});
      }
    }
    else {
      transaction.update(group.reference, {'memberIds': memberIds});
    }
  });
}