part of 'adoption_post_bloc.dart';

abstract class AdoptionPostEvent extends Equatable {
  const AdoptionPostEvent();
  @override
  List<Object> get props => [];
}

class submitPost extends AdoptionPostEvent {
  final String petName;
  final String breed;
  final String petDesc;
  final String petAge;
  final String petGender;
  final String petVacc;
  final String petSet;
  final List<String> petImg;
  final String city;

  submitPost(this.petName, this.breed, this.petDesc, this.petAge, this.petGender, this.petVacc, this.petSet, this.petImg, this.city);
  @override
  List<Object> get props => [petName, breed, petDesc,petAge,petGender,petVacc,petSet,petImg,city];
}

class deletePost extends AdoptionPostEvent{
  final String postID;
  deletePost(this.postID);
  @override
  List<Object> get props => [postID];
}