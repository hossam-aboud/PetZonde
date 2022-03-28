import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petzone/repositories/data_repository.dart';

import '../../repositories/storage.dart';

part 'lost_and_found_add_event.dart';
part 'lost_and_found_add_state.dart';

class LostAndFoundAddBloc extends Bloc<LostAndFoundAddEvent, LostAndFoundAddState> {
  final DataRepository _repository = DataRepository();
  final Storage storage = Storage();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  LostAndFoundAddBloc() : super(LostAndFoundAddInitial()) {
    on<LostAndFoundAddEvent>((event, emit) {
      on<submitLostAndFound>(_onSubmit);
      on<updateLostAndFound>(_onUpdate);
      on<deleteLostAndFound>(_onDelete);

    });
  }

  Future<FutureOr<void>> _onSubmit(submitLostAndFound event, Emitter<LostAndFoundAddState> emit) async {
    emit(LostAndFoundAddLoading());
    try{
      String uid = await _firebaseAuth.currentUser!.uid;
      List<String> imgUrl = await storage.AddLostAndFoundImg(event.petImg);

      await _repository.addLostAndFound(uid, event.petDesc, event.type, event.address, event.location, imgUrl);

      emit(LostAndFoundAddSuccess());
    }
    catch(err){
      emit(LostAndFoundAddFail(error: err.toString()));

    }


  }

  Future<FutureOr<void>> _onUpdate(updateLostAndFound event, Emitter<LostAndFoundAddState> emit) async {
    emit(LostAndFoundAddLoading());
    try{
     await  _repository.updateLostAndFound(event.postID);
      emit(LostAndFoundAddSuccess());
    }
    catch(err){
      emit(LostAndFoundAddFail(error: err.toString()));

    }
  }

  Future<FutureOr<void>> _onDelete(deleteLostAndFound event, Emitter<LostAndFoundAddState> emit) async {
    emit(LostAndFoundAddLoading());
    try{
      await  _repository.deleteLostAndFound(event.postID);
      emit(LostAndFoundAddSuccess());
    }
    catch(err){
      emit(LostAndFoundAddFail(error: err.toString()));

    }
  }
}
