//This repository is used for retrieving data from collections in firebase

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataRepository {
  final FirebaseFirestore _firestore;
  DataRepository()
      : _firestore = FirebaseFirestore.instance;
  Future<QuerySnapshot> getAdoptionPosts() async {
    return await _firestore.collection('adoption post')
        .orderBy("adopted")
        .where('adopted', isNotEqualTo: true)
        .orderBy("time", descending: true)
        .get();
  }

  Future<QuerySnapshot> getOrgAdoptionPosts() async {

    final String uid = FirebaseAuth.instance.currentUser!.uid;
    return await _firestore.collection('adoption post')
        .where("orgID", isEqualTo: uid)
        .orderBy("time", descending: true).get();
  }

  addLostAndFound(String uid, String description, String type, String address, String location,  List<String> imgUrl) async{

    await _firestore.collection('lost and found').add({
    'type': type,
    'location': location,
    'description':description,
     'address': address,
    'imgUrl': imgUrl,
    'uid': uid,
    'status': 'open',
    'time':FieldValue.serverTimestamp(),
    }).then((value) => value.update({'postID': value.id}));

  }


  Future<DocumentSnapshot> getPetLoverProfile(String uid) async {
    return await _firestore.collection('pet lovers').doc(uid).get();
  }


  Future<DocumentSnapshot> getOrgProfile(String uid) async {
    return await _firestore.collection('adoption organization').doc(uid).get();
  }

  Future<QuerySnapshot> getLostAndFoundPosts(String uid) async {
    return await _firestore.collection('lost and found')
    .where('uid', isNotEqualTo: uid)
    .orderBy('uid')
    .orderBy("time", descending: true)
    .orderBy('status')
    .limit(50)
   .get();
  }

  Future<QuerySnapshot> getMyLostAndFoundPosts(String uid) async {
    return await _firestore.collection('lost and found')
        .where('uid', isEqualTo: uid)
        .orderBy("time", descending: true)
        .orderBy('status')
        .limit(50)
        .get();
  }

  Future<void> updateLostAndFound(String postID) async {
     await _firestore.collection('lost and found')
     .doc(postID)
      .update({'status': 'closed'});
  }

  Future<void> deleteLostAndFound(String postID) async {
    await _firestore.collection('lost and found')
        .doc(postID)
        .delete();
  }

  Future<QuerySnapshot> getOrgList(String city) async {
    return await _firestore.collection('adoption organization').where('city', isEqualTo: city).get();
  }

}