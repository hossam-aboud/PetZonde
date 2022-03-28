//import 'dart:html';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petzone/repositories/user_repository.dart';
import 'package:petzone/utils/validators.dart';
import 'org_reg_event.dart';
import 'org_reg_state.dart';

class orgRegisterBloc extends Bloc<orgRegisterEvent, orgRegisterState> {
  final UserRepository _userRepository;
  final _picker = ImagePicker();


  orgRegisterBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(orgRegisterState.initial()) {
    on<RegisterEmailChanged>(_onRegisterEmail);
    on<RegisterPasswordChanged>(_onRegisterPassword);
    on<RegisterPasswordConfirmChanged>(_onRegisterPasswordConfirm);
    on<RegisterPhoneChanged>(_onRegisterPhone);
    on<RegisterPhotoChanged>(_onRegisterPicture);
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterEmail(RegisterEmailChanged event, Emitter<orgRegisterState> emit) async{
    emit(state.update(isEmailValid: Validators.isValidEmail(event.email)));
  }
  Future<void> _onRegisterPicture(RegisterPhotoChanged event, Emitter<orgRegisterState> emit) async{
    final pic = await _picker.pickImage(source: event.source);

    if(pic == null){  return;}
    emit(state.update(photoPath: pic.path));
  }

  Future<void> _onRegisterPassword(RegisterPasswordChanged event, Emitter<orgRegisterState> emit) async{

    emit(state.update(isPasswordValid: Validators.isValidPassword(event.password)));
  }

  Future<void> _onRegisterPasswordConfirm(RegisterPasswordConfirmChanged event, Emitter<orgRegisterState> emit) async{

    emit(state.update(isPasswordConfirmValid: Validators.isValidPasswordConfirm(event.password, event.passwordConfirm)));
  }

  Future<void> _onRegisterPhone(RegisterPhoneChanged event, Emitter<orgRegisterState> emit) async{

    emit(state.update(isPhoneValid: Validators.isValidPhone(event.phone)));
  }

  Future<void> _onRegisterSubmitted(RegisterSubmitted event, Emitter<orgRegisterState> emit) async {
    emit(orgRegisterState.loading());
    try {

      final key = Key.fromUtf8('key isnt to search for a meaning');
      final iv = IV.fromLength(16);

      final encrypter = Encrypter(AES(key));

      final password = encrypter.encrypt(event.password, iv: iv);

      String? uid = await _userRepository.addOrganization(event.name, event.email, password.base64, /*for sign up*/event.password,event.phone, event.city,event.license, event.website, event.description, event.photoPath);

      emit(orgRegisterState.success());
    } catch (error) {
      print('error: $error');
      emit(orgRegisterState.failure());
    }
  }

}