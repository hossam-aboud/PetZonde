import 'package:equatable/equatable.dart';

class adoptionPost extends Equatable {

  final String postID;
  final String orgID;
  final String name;
  final String petAge;
  final String breed;
  final String petDesc;
  final String petGender;
  final String city;
  final bool adopted;
  final List<dynamic> imgUrl;
  final String isSet;
  final String isVacc;
  final String? reqStatus;
  final String? reqID;


  const adoptionPost(this.postID, this.orgID, this.name, this.petAge, this.breed, this.petDesc,
      this.petGender, this.city, this.adopted, this.imgUrl, this.isSet, this.isVacc, this.reqStatus, this.reqID);

  factory adoptionPost.fromSnapshot(Map<String, dynamic> data, {String? status, String? reqID}) {
    return adoptionPost(data['postID'], data['orgID'], data['pet name'], data['pet age'], data['pet breed'], data['pet desc'], data['pet gender'],
        data['city'], data['adopted'], data['imgUrl'], data['isSet'],data['isVacc'], status, reqID);
  }

  @override
  List<Object> get props => [postID,name, petAge, petDesc, petGender, city, adopted, imgUrl, isSet, isVacc];
}