import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'poster.dart';

class lostAndFoundPost extends Equatable {
  final String postID;
  final String desc;
  final String location;
  final String type;
  final String status;
  final String address;
  final List<dynamic> imgUrl;
  final double? distance;
  final Poster? user;
  final DateTime time;

  const lostAndFoundPost(this.postID, this.desc, this.location, this.type,
      this.time, this.status, this.address, this.imgUrl,
      {this.distance, this.user});

  factory lostAndFoundPost.fromSnapshot(Map<String, dynamic> data,
      {double? distance, Poster? user}) {
    return lostAndFoundPost(
        data['postID'],
        data['description'],
        data['location'],
        data['type'],
        (data['time'] as Timestamp).toDate(),
        data['status'],
        data['address'],
        data['imgUrl'],
        distance: distance,
        user: user);
  }

  @override
  List<Object> get props =>
      [postID, desc, location, type, time, status, address, imgUrl];
}
