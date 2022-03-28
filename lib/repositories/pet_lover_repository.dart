import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PetLoverRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  addReminder(String petID, String title, String desc, String date, String repeat) async{
    await _firestore
        .collection('reminder')
        .add({
      'petID': petID,
      'title': title,
      'description': desc,
      'date': date,
      'repeat': repeat,
      'uid': uid
        })
        .then((value) => value.update({'reminderID': value.id}))
        .catchError((error) => print("Failed to add reminder: $error"));
  }
}