import 'package:equatable/equatable.dart';
import 'package:petzone/model/PetLover.dart';

class adoptionRequest extends Equatable {

  final PetLover perLover;
  final String requestID;
  final String postID;
  final bool anotherPet;
  final int isFriendly;
  final bool hasKids;
  final int type;
  final String reason;
  final String status;


  const adoptionRequest(this.postID, this.perLover, this.requestID, this.anotherPet, this.isFriendly, this.hasKids, this.type, this.reason, this.status);

  factory adoptionRequest.fromSnapshot(Map<String, dynamic> data, PetLover petLover, String postID) {

    return adoptionRequest(postID, petLover,
        data['requestID'],data['anotherPet'], data['isFriendly'],
        data['hasKids'], data['type'], data['reason'],data['status']
    );
  }

  @override
  List<Object> get props => [requestID, anotherPet, hasKids, type, reason, isFriendly, status];
}