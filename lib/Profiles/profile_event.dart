import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';


abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RegisterPhotoChanged extends ProfileEvent {}

class PLEditSubmit extends ProfileEvent {
  final DocumentSnapshot? owner;
  final String FirstName;
  final String LastName;
  final String email;
  final String phoneNum;
  final String city;
  final String birthDate;
  final String? photo;

  PLEditSubmit(this.owner,
      { required this.FirstName,
    required this.LastName,
    required this.email,
    required this.phoneNum,
    required this.city,
    required this.birthDate,
    required this.photo,
  });

  List<Object> get props {
    return [FirstName, LastName, email,  phoneNum, city, birthDate ];
  }
}


abstract class ProfileEventOrg extends Equatable {
  @override
  List<Object> get props => [];
}

class PhotoChangedOrg extends ProfileEventOrg {}

class OrgEditSubmit extends ProfileEventOrg {
  final DocumentSnapshot? owner;
  final String Name;
  final String email;
  final String phoneNum;
  final String city;
  final String description;



  OrgEditSubmit(this.owner,
      { required this.Name,
        required this.email,
        required this.phoneNum,
        required this.city,
        required this.description,
      });

  List<Object> get props {
    return [Name, email,  phoneNum, city, description ];
  }
}


// class LoudProfilePL extends ProfileEvent{
// }
// class updateProfilePL extends ProfileEvent{
//   Lisy
//   updateProfilePL(this.plm);
// }