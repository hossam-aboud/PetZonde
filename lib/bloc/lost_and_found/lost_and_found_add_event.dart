part of 'lost_and_found_add_bloc.dart';

abstract class LostAndFoundAddEvent extends Equatable {
  const LostAndFoundAddEvent();
  List<Object> get props => [];
}

class submitLostAndFound extends LostAndFoundAddEvent {
  final String petDesc;
  final String type;
  final String address;
  final List<String> petImg;
  final String location;

  submitLostAndFound(this.petDesc, this.type, this.address,this.petImg, this.location);
  @override
  List<Object> get props => [petDesc, type, address, petImg, location];
}

class updateLostAndFound extends LostAndFoundAddEvent {
  final String postID;

  updateLostAndFound(this.postID);
  @override
  List<Object> get props => [postID];
}

class deleteLostAndFound extends LostAndFoundAddEvent {
  final String postID;

  deleteLostAndFound(this.postID);
  @override
  List<Object> get props => [postID];
}