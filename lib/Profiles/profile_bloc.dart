
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petzone/Profiles/profile_event.dart';
import 'package:petzone/Profiles/profile_state.dart';
import 'package:petzone/repositories/user_repository.dart';
import 'dart:async';
import 'package:petzone/repositories/storage.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class editBloc extends Bloc<ProfileEvent,ProfileState>{
  final UserRepository _userRepository;
  final Storage storage = Storage();


  editBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(ProfileState.initial()) {
    on<PLEditSubmit>(_onEditSubmitted);
  }



  Future<void> _onEditSubmitted(PLEditSubmit event, Emitter<ProfileState> emit) async {

    emit(ProfileState.loading());
    try {
      String? url;
      if(event.photo != null){
     url =  await storage.uploadPfp(event.photo!, event.owner!['uid']);
      }
          await _userRepository.UpdatePetLover(event.owner,
          event.FirstName, event.LastName, event.email,
          event.phoneNum,event.city,event.birthDate,
             url
          );

      // if(event.photoPath != null) {
      //   await storage.uploadImg(event.photoPath!, uid!);
      // }

      emit(ProfileState.success());
    } catch (error) {
      print(error);
      emit(ProfileState.failure());
    }
  }

}
class editBlocOrg extends Bloc<ProfileEventOrg,ProfileState>{
  final UserRepository _userRepository;
  final _picker = ImagePicker();
  final Storage storage = Storage();


  editBlocOrg({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(ProfileState.initial()) {
    on<OrgEditSubmit>(_onEditSubmitted_Org);
  }




  Future<void> _onEditSubmitted_Org(OrgEditSubmit event, Emitter<ProfileState> emit) async {

    emit(ProfileState.loading());
    try {
      await _userRepository.UpdateOrg(
    event.owner,
    event.Name,
    event.email,
    event.phoneNum,
    event.city,
    event.description,
    // event.photoPath != null
    );

    // if(event.photoPath != null) {
    //   await storage.uploadImg(event.photoPath!, uid!);
    // }

    emit(ProfileState.success());
    } catch (error) {
    print(error);
    emit(ProfileState.failure());
    }
  }

// Future<void> _onRegisterPicture(RegisterPhotoChanged event, Emitter<PetLoverState> emit) async {
//   final pic = await _picker.pickImage(source: ImageSource.gallery);
//
//   if(pic == null){  return;}
//   emit(state.update(photoPath: pic.path));
// }
}
