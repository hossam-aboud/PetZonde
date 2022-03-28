import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;


  Future<bool> request(
      String postID,
      {required bool anotherPet,
      required int isFriendly,
      required bool hasKids,
      required int type,
      required String note
    }) async {

      await _firestore
      .collection('adoption post')
      .doc(postID)
      .collection('requests').add({
        "postID": postID,
        "petLoverID": uid,
        "anotherPet": anotherPet,
        "isFriendly": isFriendly,
        "hasKids": hasKids,
        "type": type,
        "reason": note,
        "status": 'Pending'
      })
      .then((value) {value.update({'requestID': value.id});})
      .catchError((error) {
      print("Failed to add request: $error");
      return false;
      });
      return true;
    }

  Future<bool> handoverRequest(String orgID, String petID, String reason, String desc) async {

    await _firestore
        .collection('handover')
        .add({
      "orgID": orgID,
      "uid": uid,
      "petID": petID,
      "reason": reason,
      "description": desc,
      "status": 'Pending',
      "time":FieldValue.serverTimestamp(),
    })
        .then((value) {value.update({'requestID': value.id});})
        .catchError((error) {
      print("Failed to add request: $error");
      return false;
    });
    return true;
  }

  Future<QuerySnapshot> getPets() async {
    return await _firestore.collection('pet').where('uid', isEqualTo: uid).get();
  }

  Future<DocumentSnapshot> getPetLoverProfile() async {
    return await _firestore.collection('pet lovers').doc(uid).get();
  }


}


