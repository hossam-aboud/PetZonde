import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petzone/model/LoginRequestData.dart';
import 'package:path/path.dart' as path;

import '../model/MedicalData.dart';

class AuthenticationService {
  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "Signed In";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // 4
  Future<String?> signUp(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return "Signed Up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

// 5
  Future<String?> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return "Signed Out";
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

// 6
  User? getUser() {
    try {
      return FirebaseAuth.instance.currentUser;
    } on FirebaseAuthException {
      return null;
    }
  }

  var firestoreInstance;
  String? uid;
  Future<bool> registerUserInfo(
      LoginRequestData loginRequestData, BuildContext context) async {
    await Firebase.initializeApp();
    firestoreInstance = FirebaseFirestore.instance;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final key = encrypt.Key.fromUtf8('key isnt to search for a meaning');
    final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final password = encrypter.encrypt(loginRequestData.password, iv: iv);
    await users
        .add({
          "email": loginRequestData.email,
          "isApproved": false,
          "password": password.base64,
          "role": "veterinarian",
        })
        .then((value) => uid = value.id)
        .catchError((error) => print("Failed to add user: $error"));

    users.doc(uid).update({'uid': uid});

    if (loginRequestData.imageFile != null) {
      loginRequestData.profileUrl = await uploadFile(context, loginRequestData,
          uid!, "profile_photo", loginRequestData.imageFile);
    }

    if (loginRequestData.paths != null) {
      int i = 1;
      for (PlatformFile file in loginRequestData.paths!) {
        XFile xfile = new XFile(file.path!);
        loginRequestData.degreeUrl =
            await uploadFile(context, loginRequestData, uid!, file.name, xfile);
        i++;
      }
    }

    /*
    if (loginRequestData.imageFile != null || loginRequestData.paths != null)
    {
      String  url="";
      List<Map<String, dynamic>> files= await loadFiles();
      for(Map<String, dynamic> file in files)
      {
        url="";
        file.forEach((k,v){
          if(k=="url")
          {
            url=v;
          }
          if(k=="description")
          {
            if(v=="profileImage")
            {
              loginRequestData.profileUrl=url;
            }
            else
            {
              loginRequestData.degreeUrl=url;
            }
          }
        });

      }
    } */
    if (await addVeterin(uid!, loginRequestData)) {
      return true;
    } else
      return false;
  }

  Future<bool> addVeterin(String id, LoginRequestData loginRequestData) async {
    bool result = false;
    await firestoreInstance.collection("veterinarian").doc(id).set({
      "degreeUrl":
          loginRequestData.paths != null ? loginRequestData.degreeUrl : null,
      "email": loginRequestData.email,
      "experience": loginRequestData.experience,
      "first name": loginRequestData.firstName,
      "last name": loginRequestData.lastName,
      "phone": loginRequestData.phoneNumber,
      "photoUrl": loginRequestData.imageFile != null
          ? loginRequestData.profileUrl
          : null,
      "speciality": loginRequestData.speciality,
      "degree": loginRequestData.degree,
      "uid": id,
    }).then((value) {
      result = true;
      return true;
    });
    return result;
  }

  Future<bool> addCreditCard(
      String id, LoginRequestData loginRequestData) async {
    bool result = false;
    await firestoreInstance.collection("creditcard").add({
      "holderName": loginRequestData.cardHolderName,
      "bankName": loginRequestData.bankName,
      "ibanNum": loginRequestData.IBanNumber,
      "consultationPrice": loginRequestData.consultPrice
    }).then((value) {
      result = true;
      return true;
    });
    return result;
  }

  FirebaseStorage? storage;

  Future<String> uploadFile(
      BuildContext context,
      LoginRequestData loginRequestData,
      String id,
      String description,
      XFile? pickedFile) async {
    storage = FirebaseStorage.instance;
    String url = '';
    final String fileName = path.basename(pickedFile!.path);
    File imageFile = File(pickedFile.path);
    try {
      // Uploading the selected image with some custom meta data
      await storage!.ref('$id/$description').putFile(imageFile);
      url = await storage!.ref('$id/$description').getDownloadURL();
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return url;
  }

  Future<List<Map<String, dynamic>>> loadFiles() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage!.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
        "description":
            fileMeta.customMetadata?['description'] ?? 'No description',
        "isMain": fileMeta.customMetadata?['isMain'] ?? 'false'
      });
    });

    return files;
  }

  Future<List<Map<String, dynamic>>> loadFilesById(String? id) async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage!.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      if (fileMeta.customMetadata?['uploaded_by'] != null &&
          fileMeta.customMetadata?['uploaded_by'] == id)
        files.add({
          "url": fileUrl,
          "path": file.fullPath,
          "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
          "description":
              fileMeta.customMetadata?['description'] ?? 'No description',
          "isMain": fileMeta.customMetadata?['isMain'] ?? 'false'
        });
    });

    return files;
  }

  Future<bool> AddPetInfo(
      MedicalData? medicalData, BuildContext context) async {
    firestoreInstance = FirebaseFirestore.instance;
    /*
    await FirebaseFirestore.instance
        .collection("pet")
        .doc()
        .delete()
        .then((_) {
      print("success!");
    });

     */
    CollectionReference users = FirebaseFirestore.instance.collection('pet');
    String userID = FirebaseAuth.instance.currentUser!.uid;
    String? petID;
    await users
        .add({
          'uid': userID,
          "age": medicalData!.age,
          "name": medicalData.name,
          "breed": medicalData.breed,
          "passport_ID": medicalData.passport_ID,
          "sterilized": medicalData.stersllized,
          "vaccinated": medicalData.vaccinated,
          "gender": medicalData.gender,
          "cat_or_dog": medicalData.cat_or_dog,
        })
        .then((value) => petID = value.id)
        .catchError((error) => print("Failed to add user: $error"));

    users.doc(petID).update({'petID': petID});
    if (medicalData.petImg != null) {
      medicalData.imgUrl = await uploadFilePet(context, medicalData, userID,
          "petImage" + userID, medicalData.petImg, 'true');
    }

    if (medicalData.paths != null) {
      for (PlatformFile file in medicalData.paths!) {
        XFile xfile = new XFile(file.path!);
        medicalData.medical_history_url = await uploadFilePet(context,
            medicalData, userID, "medical_history" + userID, xfile, 'false');
        break;
      }
    }
    if (medicalData.injections != null) {
      for (PlatformFile file in medicalData.injections!) {
        XFile xfile = new XFile(file.path!);
        medicalData.vaccination_url = await uploadFilePet(context, medicalData,
            userID, "vaccination" + userID, xfile, 'false');
        break;
      }
    }

    /* if (medicalData.petImg != null || medicalData.injections != null ||
        medicalData.paths != null
    )
    {
      String  url="";
      List<Map<String, dynamic>> files= await loadFiles();
      medicalData.img=[];
      String mainUrl='';
      for(Map<String, dynamic> file in files)
      {
        url="";
        file.forEach((k,v){
          if(k=="url")
          {
            url=v;
          }
          if(k=="description")
          {
            if(v=="vaccination"+userID)
            {
              medicalData.vaccination_url=url;
            }
            else if(v=="medical_history"+userID)
            {
              medicalData.medical_history_url=url;
            }
            else if(v=="petImage"+userID)
            {
              medicalData.imgUrl = url;
            }
          }
        });

      }
    } */
    if (await submitPet(petID!, medicalData)) {
      return true;
    } else
      return false;
  }

  Future<bool> submitPet(String petID, MedicalData medicalData) async {
    bool result = false;
    CollectionReference pet = FirebaseFirestore.instance.collection('pet');

    await pet.doc(petID).update({
      'medical_history_url': medicalData.medical_history_url ?? null,
      'vaccination_url': medicalData.vaccination_url ?? null,
      'img': medicalData.imgUrl
    }).then((value) {
      result = true;
      return true;
    }).catchError((error) => print("Failed to update user: $error"));
    ;

    return result;
  }

  Future uploadFilePet(
      BuildContext context,
      MedicalData loginRequestData,
      String id,
      String description,
      XFile? pickedfile,
      String isMainProfile) async {
    storage = FirebaseStorage.instance;
    final String fileName = path.basename(pickedfile!.path);
    File imageFile = File(pickedfile.path);
    String? url;
    try {
      // Uploading the selected image with some custom meta data
      await storage!.ref(fileName).putFile(
          imageFile,
          SettableMetadata(customMetadata: {
            'uploaded_by': id,
            'description': description,
            'isMain': isMainProfile
          }));
      url = await storage!.ref(fileName).getDownloadURL();
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }

    return url;
  }

  Future<List<MedicalData>> getAllPets() async {
    List<MedicalData> AllPets = [];
    String userID = FirebaseAuth.instance.currentUser!.uid;

    var collection = await FirebaseFirestore.instance.collection('pet');
    var querySnapshot = await collection.where('uid', isEqualTo: userID).get();

    for (var snapshot in querySnapshot.docs) {
      Map<String, dynamic> data = snapshot.data();
      MedicalData model = MedicalData();
      model.name = data['name'];
      model.passport_ID = data['passport_ID'];
      model.breed = data['breed'];
      model.age = data['age'];
      model.gender = data['gender'];
      model.stersllized = data['sterilized'];
      model.vaccinated = data['vaccinated'];
      model.cat_or_dog = data['cat_or_dog'];
      model.uid = snapshot.id;
      if (data['img'] != null) {
        model.imgUrl = data['img'];
      }
      if (data['vaccination_url'] != null)
        model.vaccination_url = data['vaccination_url'];
      if (data['medical_history_url'] != null)
        model.medical_history_url = data['medical_history_url'];
      AllPets.add(model);
    }
    return AllPets;
  }

  Future<bool> UpdatePetInfo(
      MedicalData? medicalData, BuildContext context) async {
    await Firebase.initializeApp();
    firestoreInstance = FirebaseFirestore.instance;
    CollectionReference users = FirebaseFirestore.instance.collection('pet');
    bool result = false;
    uid = medicalData!.uid;
    /*
    var batch;
    final post = await FirebaseFirestore.instance
        .collection('pet')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
      //Here we get the document reference and return to the post variable.
      batch= snapshot.docs[0].reference;
    });

     */
    await users.doc(uid).update({
      'uid': uid,
      "age": medicalData.age,
      "name": medicalData.name,
      "passport_ID": medicalData.passport_ID,
      "breed": medicalData.breed,
      "stersllized": medicalData.stersllized,
      "gender": medicalData.gender,
      "cat_or_dog": medicalData.cat_or_dog,
      "vaccination": medicalData.vaccinated
    });


    if (medicalData.petImg != null) {
      await uploadFilePet(context, medicalData, uid!, "petImage" + uid!,
          medicalData.petImg, "new");
    }
    if (medicalData.paths != null) {
      int i = 1;
      for (PlatformFile file in medicalData.paths!) {
        XFile xfile = new XFile(file.path!);
        await uploadFilePet(context, medicalData, uid!,
            "medical_history" + uid!, xfile, "false");
        break;
        i++;
      }
    }

    String mainUrl = "";
    String EditUrl = "";
    if (medicalData.petImg != null ||
        medicalData.injections != null ||
        medicalData.paths != null) {
      String url = "";
      List<Map<String, dynamic>> files = await loadFilesById(uid);

      for (Map<String, dynamic> file in files) {
        url = "";
        bool ismainUrl = false;

        bool isEdit = false;

        file.forEach((k, v) {
          if (k == "url") {
            url = v;
          }
          if (k == "description") {
            if (v == "vaccination" + uid!) {
              medicalData.vaccination_url = url;
            } else if (v == "medical_history" + uid!) {
              medicalData.medical_history_url = url;
            } else if (v == "petImage" + uid!) {

              medicalData.imgUrl = url;
            }
          }
          if (k == "isMain") {
            if (v == "new") {
              ismainUrl = false;
              isEdit = true;
              EditUrl = url;
            } else if (v == "true") {
              ismainUrl = true;
              isEdit = false;
              mainUrl = url;
            }
          }
        });
      }
    }
    List<String>? newimg = [];
    if (mainUrl != "" || EditUrl != "") {
    }
    if (await submitPet(uid!, medicalData)) {
      return true;
    } else
      return false;
  }
}
