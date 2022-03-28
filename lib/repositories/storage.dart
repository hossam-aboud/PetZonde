import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart' as fb_core;
import 'dart:io';
class Storage {
  final fb_storage = FirebaseStorage.instance;


  Future<File> uploadImg(String path, String uid) async {
    File file = File(path);

    // maybe it will be in a user folder?
    try {
      await fb_storage.ref('$uid/profile_photo').putFile(file);
    } on fb_core.FirebaseException catch (e) {
      print(e);
    }

    return file;

  }

  Future<String> uploadPfp(String path, String uid) async{
    File file = File(path);
    String url = '';
    try {
      await fb_storage.ref('$uid/profile_photo').putFile(file);
       url = await fb_storage.ref('$uid/profile_photo').getDownloadURL();
    } on fb_core.FirebaseException catch (e) {
      print(e);
    }
    return url;
  }


  Future<String> downloadURL(String uid) async{
    String url = await fb_storage.ref('$uid/profile_photo').getDownloadURL();
    return url;
  }

  Future<String> GetAdoptionImage(String uid, String name) async{
    String url = await fb_storage.ref('$uid/adoption/$name').getDownloadURL();

    return url;

  }

  Future<List<String>> AddAdoptionImg(List<String> paths, String uid, String name) async {
    DateTime date = DateTime.now();
    List<String> urlList = [];
    for(String path in paths) {
      int i = paths.indexOf(path);
      File file = File(path);
      try {
        await fb_storage.ref('$uid/adoption/$date/$name.$i').putFile(file);
      String url = await fb_storage.ref('$uid/adoption/$date/$name.$i').getDownloadURL();
        urlList.add(url);
      } on fb_core.FirebaseException catch (e) {
        print(e);
      }
    }

    return urlList;

  }


  Future<List<String>> AddLostAndFoundImg(List<String> paths) async {
    DateTime date = DateTime.now();
    List<String> urlList = [];
    for(String path in paths) {
      int i = paths.indexOf(path);
      File file = File(path);
      try {
        await fb_storage.ref('lostAndFound/$date.$i').putFile(file);
      String url = await fb_storage.ref('lostAndFound/$date.$i').getDownloadURL();
        urlList.add(url);
      } on fb_core.FirebaseException catch (e) {
        print(e);
      }
    }

    return urlList;

  }

}