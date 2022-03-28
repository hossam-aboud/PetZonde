import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:petzone/repositories/storage.dart';



class UserRepository {
  final Storage storage = Storage();
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  UserRepository()
      : _firebaseAuth = FirebaseAuth.instance, _firestore = FirebaseFirestore.instance;

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential?> signUp(String email, String password) async {
    try{
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');

      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<void>> signOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<User> getUser() async {
    final currentUser = await _firebaseAuth.currentUser;
    return currentUser!;
  }

  Future<String?> addOrganization(String name, String email, String EncryptPass, String password, String phone,
      String city, String license, String website, String description, String? photo) async {
    UserCredential? userCredential = await signUp(email, password);
    if (userCredential!.user != null) {
      String uid = userCredential.user!.uid;
      String? token = await FirebaseMessaging.instance.getToken();
      List<dynamic> tokens = [];
      tokens.add(token!);

      CollectionReference org = FirebaseFirestore.instance.collection(
          'adoption organization');
      CollectionReference users = FirebaseFirestore.instance.collection(
          'users');

      await org.doc(uid).set({
        'uid':uid,
        'name': name,
        'email': email,
        'phone': phone,
        'city': city,
        'licenseNumber': license,
        'website': website,
        'description': description,
      })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));


      await users.doc(uid).set({
        'uid': uid,
        'email': email,
        'password': EncryptPass,
        'isApproved': false,
        'role': 'adoption organization',
        'tokens': tokens,
      })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));


      if (photo != null) {
        await storage.uploadImg(photo, uid);
        String url = await storage.downloadURL(uid);
        org.doc(uid).update({'uid': uid, 'photoUrl': url});
      }

      else {
        org.doc(uid).update({'uid': uid, 'photoUrl': null});
      }


      return uid;
    }
    else {
      return null;
    }
  }

  Future<String?> addPetLover(String firstName, String lastName,String email, String password, String phoneNum, String city , String birthDate, String? photo, bool petSetter) async {
    UserCredential? userCredential = await signUp(email, password);
    if(userCredential!.user != null){
      String uid = userCredential.user!.uid;
      CollectionReference PetLovers = FirebaseFirestore.instance.collection('pet lovers');
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      String? token = await FirebaseMessaging.instance.getToken();
      List<String> tokens = [];
      tokens.add(token!);

      await PetLovers.doc(uid).set({
        'uid': uid,
        'first name': firstName,
        'last name': lastName,
        'email': email,
        'phone number': phoneNum,
        'city': city,
        'birth date': birthDate,
        'pet setter': petSetter
      })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));

      await users.doc(uid).set({
        'uid': uid,
        'email': email,
        'isApproved':  true,
        'role': 'Pet Lover',
        'tokens': tokens,
      })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));

      if(photo!=null) {
        await storage.uploadImg(photo, uid);
        String url =  await storage.downloadURL(uid);
        PetLovers.doc(uid).update({'photoUrl': url});
      }
      else {
        PetLovers.doc(uid).update({'uid': uid, 'photoUrl': null});
      }

      return uid;
    }

    else{
      return null;
    }
  }

  Future<String?> UpdatePetLover(DocumentSnapshot? owner,String firstName, String lastName,String email, String phoneNum,
      String city , String birthDate, String? url,
      ) async {
    User? user = FirebaseAuth.instance.currentUser;

    if(user != null){

      String uid = user.uid.toString();
      DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(user.uid);
      owner?.reference.update({
        'first name': firstName,
        'last name': lastName,
        'phone number': phoneNum,
        'photoUrl': url ?? owner['photoUrl'],
        'city': city,
        'birth date': birthDate,
      })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to update user: $error"));

      FirebaseAuth.instance.currentUser!
          .updateEmail(email)
          .catchError((error) => print("Failed to update user email1 : $error"));


      owner?.reference.update({'email': email});
      userRef.update({'email':email})
      //   FirebaseFirestore.instance.collection('users').where('uid', isEqualTo:  uid).snapshots()
          .catchError((error) => print("Failed to update user email2 : $error"));



      // FirebaseFirestore.instance.
      // collection('users').where('uid', isEqualTo:  getuser().toString())
      //     .get()
      //     .then((QuerySnapshot querySnapshot) {
      //   querySnapshot.docs[0]["email"];
      //     }).catchError((error) => print(uid+" $error"));


    }
  }
  Future<String?> UpdateOrg(DocumentSnapshot? owner,String Name,String email, String phoneNum, String city , String description,
      // bool photo
      ) async {
    User? user = FirebaseAuth.instance.currentUser;

    if(user != null){

      String uid = user.uid.toString();
      DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(user.uid);
      owner?.reference.update({
        'name': Name,
        'email': email,
        'phone': phoneNum,
        // 'licenseNumber': license,
        // 'website': website,
        'description': description,
      })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to update user: $error"));

      FirebaseAuth.instance.currentUser!
          .updateEmail(email)
          .catchError((error) => print("Failed to update user email1 : $error"));


      owner?.reference.update({'email': email});
      userRef.update({'email':email})
      //   FirebaseFirestore.instance.collection('users').where('uid', isEqualTo:  uid).snapshots()
          .catchError((error) => print("Failed to update user email2 : $error"));

    }
  }

}


DocumentReference getuser() {
  User? user = FirebaseAuth.instance.currentUser;
  return FirebaseFirestore.instance.collection('pet lovers').doc(user?.uid);
}


