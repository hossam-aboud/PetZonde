import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class orgRegisterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RegisterEmailChanged extends orgRegisterEvent {
  final String email;

  RegisterEmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class RegisterPasswordChanged extends orgRegisterEvent {
  final String password;

  RegisterPasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class RegisterPasswordConfirmChanged extends orgRegisterEvent {
  final String password;
  final String passwordConfirm;

  RegisterPasswordConfirmChanged({required this.password, required this.passwordConfirm});

  @override
  List<Object> get props => [password,passwordConfirm];
}

class RegisterPhoneChanged extends orgRegisterEvent {
  final String phone;

  RegisterPhoneChanged({required this.phone});

  @override
  List<Object> get props => [phone];
}

class RegisterPhotoChanged extends orgRegisterEvent {
  final ImageSource source;

  RegisterPhotoChanged({required this.source});

  @override
  List<Object> get props => [source];
}

class RegisterSubmitted extends orgRegisterEvent {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String city;
  final String license;
  final String website;
  final String description;
  final String? photoPath;

  RegisterSubmitted(this.photoPath, {required this.name, required this.email, required this.password, required this.phone, required this.city, required this.license,required this.website,required this.description});

  @override
  List<Object> get props => [photoPath.toString(),name,email, password,phone,city,license,website, description];
}