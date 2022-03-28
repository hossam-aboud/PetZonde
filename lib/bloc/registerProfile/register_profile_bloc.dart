import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:encrypt/encrypt.dart';
import 'package:meta/meta.dart';
import 'package:petzone/model/UserRegister.dart';
import 'package:petzone/repositories/mail.dart';
import 'package:petzone/repositories/user_repository.dart';
import 'package:petzone/repositories/admin_repository.dart';


part 'register_profile_event.dart';
part 'register_profile_state.dart';

class RegisterProfileBloc extends Bloc<RegisterProfileEvent, RegisterProfileState> {
  final AdminRepository _adminRepository ;
  final Mail mail = Mail();
  RegisterProfileBloc({required AdminRepository adminRepository}) :_adminRepository = adminRepository,
        super(LoadingState()) {
    on<LoadProfileEvent>(_onLoading);
    on<UpdateProfileEvent>(_onUpdateUser);
    on<ApproveUserEvent>(_onApproveUser);
    on<DisapproveUserEvent>(_onDisapproveUser);
  }

  void _onLoading(LoadProfileEvent event, Emitter<RegisterProfileState> emit){
    emit(LoadingState());
  }


  void _onUpdateUser(UpdateProfileEvent event, Emitter<RegisterProfileState> emit) async{
emit(LoadedState());
  }
  
  void _onApproveUser(ApproveUserEvent event, Emitter<RegisterProfileState> emit) async{
    User? user = event.user;
    final encPassword = await _adminRepository.getPassword(user.uid);
    final key = Key.fromUtf8('key isnt to search for a meaning');
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));
    final password = encrypter.decrypt(Encrypted.fromBase64(encPassword), iv: iv);


    String newUid = await UserRepository().signUp(user.email, password).then((firebaseUser) {
      if(firebaseUser!.user != null)
        return firebaseUser.user!.uid;
      else return '';
    });
   _adminRepository.approveUser(user.uid, newUid);
   /* mail.sendEmail(
      message: 'We\'re happy to inform you that your registration request has been accepted. Please Login into your account to access the application and join the PetZone Family.',
      subject: 'Welcome To PetZone',
      name:  user.name,
      email: user.email
      ); */

    emit(UpdatedState('Approved'));

  }
  
  void _onDisapproveUser(DisapproveUserEvent event, Emitter<RegisterProfileState> emit){
    User? user = event.user;

   _adminRepository.deleteUser(user.uid);

   /* mail.sendEmail(
        message: 'After careful review, we regret to inform you that PetZone Team have decided to decline your registration request since your profile was not lining up with what we we\'re looking for. '
        'Thank you for your time and interest in PetZone.',
        subject: 'PetZone Registration Request',
        name: user.name,
        email:user.email
    ); */

    emit(UpdatedState('Rejected'));
  }
  
  
  
}
