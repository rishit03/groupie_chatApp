import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});


  // reference for our collection
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection("groups");




  // saving the userData
  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName" : fullName,
      "email" : email,
      "groups" : [],
      "profilePic" : "",
      "uid" : uid,
    });

  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot = await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  // creating a group
  Future createGroup(String userName, String Id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName" : groupName,
      "groupIcon" : "",
      "admin" : "${uid}_$userName",
      "members" : [],
      "groupId" : "",
      "recentMessages" : "",
      "recentMessageSender" : "",

    });

    // update the members
    await groupDocumentReference.update({
      "members" : FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId" : groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = await userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups" : FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  // getting the chats
  getChats(String groupId) async {
    return groupCollection.doc(groupId).collection("messages").orderBy("time").snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // getting group members
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

}
