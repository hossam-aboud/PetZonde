import 'package:equatable/equatable.dart';

class Pet extends Equatable{
  final String petID;
  final String petName;
  final String petAge;
  final String petType;
  final String petGender;
  final String petBreed;
  final String isSet;
  final String isVacc;
  final String imgUrl;

  Pet(this.petID, this.petName, this.petAge, this.petType, this.petGender, this.petBreed, this.isSet, this.isVacc, this.imgUrl);

  factory Pet.fromSnapshot(Map<String, dynamic> data) {

    return Pet(
        data['petID'],data['name'], data['age'],
        data['cat_or_dog'], data['gender'], data['breed'],data['sterilized'], data['vaccinated'], data['img']
    );
  }

  @override
  List<Object> get props => [petID, petName, petAge, petType, petGender, petBreed, isSet, isVacc];
}