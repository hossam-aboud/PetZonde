import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DecisionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> request(
      String status,
      String postId,
      String requestId) async {

    if (status == 'Approved'){

      await _firestore
          .collection('adoption post')
          .doc(postId)
          .update({
        "adopted": true
      })
          .catchError((error) {
        print("Failed to add request: $error");
        return false;
      });
      reject(postId, requestId);

    }

    await _firestore
        .collection('adoption post')
        .doc(postId)
        .collection('requests').doc(requestId).update({
      "status": status
    })
        .catchError((error) {
      print("Failed to add request: $error");
      return false;
    });

      return true;
    }

    Future<void> reject(postId, reqID) async {
   _firestore
      .collection('adoption post')
      .doc(postId)
      .collection('requests')
      .where('requestID', isNotEqualTo: reqID)
      .get().then((snapshot)
       {for(var doc in snapshot.docs){
         doc.reference.update({'status': 'Rejected'});
       }});
  }


  Future<void> handoverDecision(String status, String requestID) async {
    _firestore.collection('handover').doc(requestID).update({'status': status});

  }

}
