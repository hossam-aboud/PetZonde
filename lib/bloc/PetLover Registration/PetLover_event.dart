
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class PLRegEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RegisterEmailChanged extends PLRegEvent {
  final String email;

  RegisterEmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class RegisterPasswordChanged extends PLRegEvent {
  final String password;

  RegisterPasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class RegisterConfPasswordChanged extends PLRegEvent {
  final String password;
  final String Confpassword;

  RegisterConfPasswordChanged({required this.password,required this.Confpassword});

  @override
  List<Object> get props => [Confpassword];
}
class RegisterPhoneChanged extends PLRegEvent {
  final String phone;

  RegisterPhoneChanged({required this.phone});

  @override
  List<Object> get props => [phone];
}

class RegisterPhotoChanged extends PLRegEvent {
  final ImageSource source;

  RegisterPhotoChanged({required this.source});

  @override
  List<Object> get props => [source];
}

class PLRegSubmit extends PLRegEvent {
  final String FirstName;
  final String LastName;
  final String email;
  final String password;
  final String phoneNum;
  final String img;
  final String city;
  final String birthDate;
  final String? photoPath;
  final bool petSetter;


  PLRegSubmit(this.photoPath,{ required this.FirstName,
    required this.LastName,
    required this.email,
    required this.password,
    required this.phoneNum,
    required this.img,
    required this.city,
    required this.birthDate,
    required this.petSetter});

  List<Object> get props {
    return [FirstName, LastName, email, password, img, city, birthDate ,petSetter];
  }
}
// class PLRegSubmit extends PLRegEvent{
//   final String FirstName;
//   final String LastName;
//   final String email;
//   final String password;
//   final String phoneNum;
//   final String img;
//   final String city;
//   final String birthDate;
//
//
//   PLRegSubmit({    required this.FirstName,
//     required this.LastName,
//     required this.email,
//     required this.password,
//     required this.phoneNum,
//     required this.img,
//     required this.city,
//     required this.birthDate});
//   List<Object> get props {
//     return [FirstName,LastName,email,password,img,city,birthDate];
//   }
//
//