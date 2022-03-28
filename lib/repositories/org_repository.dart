import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petzone/repositories/storage.dart';


import '../model/UserRegister.dart';

class OrgRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<bool> addAdoptPost(

      // to be added: breed. added: post id and org id
      //added time so that recent posts  first
      String uid, String name,String breed, String desc, String age,
      String gender, var vac, var set,
      String city, List<String> img) async {

    await _firestore.collection('adoption post')
        .add({
      'orgID': uid,
      'pet name': name,
      'pet breed':breed,
      'pet desc': desc,
      'pet age': age,
      'pet gender': gender,
      'isVacc': vac,
      'isSet': set,
      'city': city,
      'imgUrl': img,
      'time':FieldValue.serverTimestamp(),
      'adopted': false,
    })
        .then((value) {value.update({'postID': value.id});})
        .catchError((error) {
      print("Failed to add post: $error");
      return false;
    });
    return true;

  }

  Future<DocumentSnapshot> getPetLoverProfile(String uid) async {
    return await _firestore.collection('pet lovers').doc(uid).get();
  }

  Future<DocumentSnapshot> getOrgProfile(String uid) async {
    return await _firestore.collection('adoption organization').doc(uid).get();
  }

  Future<DocumentSnapshot> getPetProfile(String petID) async {
    return await _firestore.collection('pet').doc(petID).get();
  }

  Future<QuerySnapshot> getAdoptionRequests(String postID) async {
    return await _firestore.collection('adoption post')
        .doc(postID)
        .collection('requests')
        .get();
  }

  deleteAdoptPost(String postID) async {
    return await _firestore.collection('adoption post').doc(postID).delete();
  }

  Future<QuerySnapshot> getHandoverRequests() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return await _firestore.collection('handover')
        .where('orgID', isEqualTo: uid)
        .orderBy('status')
        .orderBy("time", descending: true)
        .limit(50)
        .get();
  }

  Future<QuerySnapshot> getPetLoverHandoverRequests() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    return await _firestore.collection('handover')
        .where('uid', isEqualTo: uid)
        .orderBy('status')
        .orderBy("time", descending: true)
        .limit(50)
        .get();

  }

cancelHandover(String requestID) async{
    await  _firestore.collection('handover')
        .doc(requestID)
        .delete();
}

}