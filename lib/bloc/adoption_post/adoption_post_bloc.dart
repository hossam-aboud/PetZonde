import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petzone/repositories/org_repository.dart';
import 'package:petzone/repositories/storage.dart';

part 'adoption_post_event.dart';

part 'adoption_post_state.dart';

class AdoptionPostBloc extends Bloc<AdoptionPostEvent, AdoptionPostState> {
  final OrgRepository _orgRepository = OrgRepository();
  final Storage storage = Storage();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AdoptionPostBloc() : super(AdoptionPostInitial()) {
      on<submitPost>(_onSubmit);
      on<deletePost>(_onDelete);
  }

  Future<FutureOr<void>> _onSubmit(
      submitPost event, Emitter<AdoptionPostState> emit) async {
    emit(SubmitAdoptionPostLoading());
    try {
      String uid = await _firebaseAuth.currentUser!.uid;
      List<String> imgUrl =
          await storage.AddAdoptionImg(event.petImg, uid, event.petName);

      bool? result = await _orgRepository.addAdoptPost(
          uid,
          event.petName,
          event.breed,
          event.petDesc,
          event.petAge,
          event.petGender,
          event.petVacc,
          event.petSet,
          event.city,
          imgUrl);

      if (result) {
        emit(SubmitAdoptionPostSuccess());      }
    } catch (err) {
      emit(SubmitAdoptionPostFail(error: err.toString()));
    }
  }

  Future<FutureOr<void>> _onDelete(
      deletePost event, Emitter<AdoptionPostState> emit) async {
    await _orgRepository.deleteAdoptPost(event.postID);
    emit(SubmitAdoptionPostSuccess());
  }
}
