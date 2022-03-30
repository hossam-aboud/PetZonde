
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/UserRegister.dart';

class AdminRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Future<User?>>> getRegisterRequestList(String tag) {
    switch (tag) {
      case "Vet":
        return _firestore
            .collection('users')
            .where('isApproved', isEqualTo: true)
            .where('role', isEqualTo: 'veterinarian')
            .snapshots()
            .map((event) {
          return event.docs
              .map((d) => getUserDetails(d['uid'].toString(), 'veterinarian'))
              .toList();
        });
      case "Org":
        return _firestore
            .collection('users')
            .where('role', isEqualTo: 'adoption organization')
            .snapshots()
            .map((event) {
          return event.docs
              .map((d) =>
                  getUserDetails(d['uid'].toString(), 'adoption organization'))
              .toList();
        });
      case 'Pet':
        return _firestore
            .collection('users')
            .where('role', isEqualTo: 'Pet Lover')
            .snapshots()
            .map((event) {
          return event.docs
              .map((d) => getUserDetails(d['uid'].toString(), 'Pet Lover'))
              .toList();
        });
      case 'All':
      default:
        return _firestore
            .collection('users')
            .where('isApproved', isEqualTo: true)
            .snapshots()
            .map((event) {
          return event.docs
              .map((d) => getUserDetails(d['uid'].toString()))
              .toList();
        });
    }
  }

  Future<String> getUserRole(String uid) async {
    String role = '';
    await _firestore
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get()
        .then((user) {
      role = user.docs.first['role'].toString();
    });

    return role;
  }

  Future<User?> getUserDetails(String uid, [String? userRole]) async {
    User? _user = null;
    final role = userRole == null ? await getUserRole(uid) : userRole;

    if (role == '') return _user;
    switch (role) {
      case 'veterinarian':
        await _firestore
            .collection('veterinarian')
            .doc(uid)
            .get()
            .then((user) async {
          String uID = user['uid'];
          String fn = user['first name'];
          String ln = user['last name'];
          String? photo = user['photoUrl'] == null ? null : user['photoUrl'];
          String e = user['email'];
          String phone = user['phone'];
          String ex = user['experience'];
          String degree = user['degreeUrl'];
          String spc = user['speciality'];
          _user = Vet(
              uid: uID,
              name: fn + ' ' + ln,
              photo: photo,
              phone: phone,
              email: e,
              experience: ex,
              degree: degree,
              specialty: spc);
        });
        break;
      case 'adoption organization':
        await _firestore
            .collection('adoption organization')
            .doc(uid)
            .get()
            .then((user) async {
          String uid = user['uid'];
          String n = user['name'];
          String? photo = user['photoUrl'] == null ? null : user['photoUrl'];
          String e = user['email'];
          String phone = user['phone'];
          String desc = user['description'];
          String loc = user['city'];
          String website = user['website'];
          String license = user['licenseNumber'];

          _user = Org(
              uid: uid,
              name: n,
              photo: photo,
              phone: phone,
              email: e,
              description: desc,
              location: loc,
              website: website,
              license: license);
        });
        break;
      case 'Pet Lover':
        await _firestore
            .collection('pet lovers')
            .doc(uid)
            .get()
            .then((user) async {
          String uid = user['uid']; //
          String fname = user['first name']; //
          String lname = user['last name']; //
          String? photo = user['photoUrl'] == null ? null : user['photoUrl']; //
          String email = user['email']; //
          String phone = user['phone number']; //
          String birth = user['birth date']; //
          String city = user['city']; //
          bool isPetSetter = user['pet setter'];
          _user = PetLover(
            uid: uid,
            name: fname + ' ' + lname,
            phone: phone,
            email: email,
            petterSetter: isPetSetter,
            city: city,
            birth_date: birth,
            photo: photo,
          );
        });
        break;
    }
    return _user;
  }

  void deleteUser(String uid) async {
    final role = await getUserRole(uid);
    if (role == '') return;
    await _firestore
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get()
        .then((snapshot) {
      snapshot.docs[0].reference.delete();
    });

    await _firestore
        .collection(role)
        .where('uid', isEqualTo: uid)
        .get()
        .then((snapshot) {
      snapshot.docs[0].reference.delete();
    });
  }

  void approveUser(String uid, String newUid) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await _firestore
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get()
        .then((snapshot) async {
      final user = snapshot.docs.first;
      users.doc(newUid).set({
        'role': user['role'],
        'email': user['email'],
        'isApproved': true,
        'uid': newUid
      });
      user.reference.delete();
      updateUid(uid, newUid, user['role']);
    }).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateUid(
      String oldUid, String newUid, String collection) async {
    CollectionReference org = _firestore.collection('adoption organization');
    CollectionReference vet = _firestore.collection('veterinarian');
    await _firestore
        .collection(collection)
        .where('uid', isEqualTo: oldUid)
        .get()
        .then((snapshot) async {
      final user = snapshot.docs.first;

      if (collection == 'adoption organization')
        org.doc(newUid).set({
          'uid': newUid,
          'name': user['name'],
          'email': user['email'],
          'phone': user['phone'],
          'city': user['city'],
          'licenseNumber': user['licenseNumber'],
          'website': user['website'],
          'description': user['description'],
          'photoUrl': user['photoUrl'],
        });

      if (collection == 'veterinarian')
        vet.doc(newUid).set({
          'uid': newUid,
          'first name': user['first name'],
          'last name': user['last name'],
          'email': user['email'],
          'phone': user['phone'],
          'experience': user['experience'],
          'speciality': user['speciality'],
          'degree': user['degree'],
          'degreeUrl': user['degreeUrl'],
          'photoUrl': user['photoUrl'],
        });

      user.reference.delete();
    }).catchError((error) => print("Failed to update user: $error"));
    ;
  }

  Future<String> getPassword(String uid) async {
    return await _firestore
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get()
        .then((snapshot) async {
      return snapshot.docs.first['password'];
    }).catchError((error) => print("Failed to update user: $error"));
  }
}
