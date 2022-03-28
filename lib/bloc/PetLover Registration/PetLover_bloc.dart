
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petzone/repositories/user_repository.dart';
import 'package:petzone/utils/validators.dart';
import 'PetLover_event.dart';
import 'PetLover_state.dart';



class PetLoverBloc extends Bloc<PLRegEvent,PetLoverState>{
  final UserRepository _userRepository;
  final _picker = ImagePicker();


  PetLoverBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(PetLoverState.initial()) {
    on<RegisterEmailChanged>(_onRegisterEmail);
    on<RegisterPasswordChanged>(_onRegisterPassword);
    on<RegisterConfPasswordChanged>(_onRegisterConfPassword);
    on<RegisterPhoneChanged>(_onRegisterPhone);
    on<RegisterPhotoChanged>(_onRegisterPicture);
    on<PLRegSubmit>(_onRegisterSubmitted);

  }

  Future<void> _onRegisterEmail(RegisterEmailChanged event, Emitter<PetLoverState> emit) async{
    emit(state.update(isEmailValid: Validators.isValidEmail(event.email)));
  }

  Future<void> _onRegisterPassword(RegisterPasswordChanged event, Emitter<PetLoverState> emit) async{

    emit(state.update(isPasswordValid: Validators.isValidPassword(event.password)));
  }
  Future<void> _onRegisterConfPassword(RegisterConfPasswordChanged event ,Emitter<PetLoverState> emit) async{

    emit(state.update(isPasswordConfirmValid: Validators.isValidPasswordConfirm(event.password ,event.Confpassword)));
  }

  Future<void> _onRegisterPhone(RegisterPhoneChanged event, Emitter<PetLoverState> emit) async{

    emit(state.update(isPhoneValid: Validators.isValidPhone(event.phone)));
  }

  Future<void> _onRegisterSubmitted(PLRegSubmit event, Emitter<PetLoverState> emit) async {

    emit(PetLoverState.loading());
    try {


      await _userRepository.addPetLover(
          event.FirstName, event.LastName, event.email, event.password,
          event.phoneNum,event.city,event.birthDate, event.photoPath, event.petSetter);



      emit(PetLoverState.success());
    } catch (error) {
      print(error);
      emit(PetLoverState.failure());
    }
  }


  Future<void> _onRegisterPicture(RegisterPhotoChanged event, Emitter<PetLoverState> emit) async {


    final pic = await _picker.pickImage(source: event.source);

    if(pic == null){  return;}
    emit(state.update(photoPath: pic.path));
  }
}
