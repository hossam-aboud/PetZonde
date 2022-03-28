import 'package:equatable/equatable.dart';
import 'package:petzone/model/PetLover.dart';
import 'package:petzone/model/poster.dart';

import 'Pet.dart';

class Handover extends Equatable{
  final String requestID;
  final String reason;
  final String description;
  final String status;
  final Pet pet;
  final PetLover? petLover;
  final Poster? org;


  const Handover(this.requestID, this.reason, this.description, this.status, this.pet, this.petLover, this.org);

  factory Handover.fromSnapshot(Map<String, dynamic> data, Pet pet, {PetLover? pl, Poster? user}){
    return Handover(data['requestID'], data['reason'], data['description'],data['status'], pet, pl, user);
  }

  @override
  List<Object?> get props => [requestID, reason, description, status, pet, petLover, org];
}