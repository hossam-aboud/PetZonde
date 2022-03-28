import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Repository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  Repository()
      : _firebaseAuth = FirebaseAuth.instance, _firestore = FirebaseFirestore.instance;


  Future<String> getUser() async {
    final currentUser = await _firebaseAuth.currentUser;
    return currentUser!.uid.toString();
  }

  Future<String> getReq() async {

      String? uid = getUser() as String?;
      CollectionReference req = FirebaseFirestore.instance.collection('requests');
      CollectionReference users = FirebaseFirestore.instance.collection('users');


      return req.doc(uid).get().toString();

  }

  Future<void> cancelReq(String postID, String reqID) async {
     await _firestore
        .collection('adoption post')
        .doc(postID)
        .collection('requests')
        .doc(reqID)
        .delete();
  }

  Future<DocumentSnapshot> getAdoptionPost(String postID) async {
    return await _firestore
        .collection('adoption post')
        .doc(postID)
        .get();
  }


  Future<QuerySnapshot> getOrgAdoptionPostsReq() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    return await _firestore
        .collectionGroup('requests')
        .where('petLoverID' , isEqualTo: uid)
        .where('status' , isNotEqualTo: 'Rejected')
        .get();
  }
}
