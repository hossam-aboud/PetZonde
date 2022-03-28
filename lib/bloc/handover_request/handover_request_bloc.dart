  import 'dart:async';

  import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:equatable/equatable.dart';
import 'package:petzone/model/Pet.dart';
  import 'package:petzone/repositories/request_repository.dart';

import '../../model/PetLover.dart';

  part 'handover_request_event.dart';
  part 'handover_request_state.dart';

  class HandoverRequestBloc extends Bloc<HandoverRequestEvent, HandoverRequestState> {
    RequestRepository _repository = RequestRepository();
    HandoverRequestBloc() : super(HandoverRequestInitial()) {
      on<LoadPets>(_onLoad);
      on<SubmitHandoverRequest>(_SendRequest);

    }

    Future<FutureOr<void>> _onLoad(LoadPets event, Emitter<HandoverRequestState> emit) async {
  try{
    final petSnapshot = await _repository.getPets();

    if(petSnapshot.docs.isEmpty) emit(HandoverRequestEmpty());

    List<Pet> petList = [];
  for(var doc in petSnapshot.docs){
    Pet pet = Pet.fromSnapshot(doc.data() as  Map<String, dynamic>);
    petList.add(pet);
  }
  emit(HandoverRequestLoaded(petList));}

  catch(error){
    emit(HandoverRequestFail(error.toString()));
  }

    }

    FutureOr<void> _SendRequest(SubmitHandoverRequest event, Emitter<HandoverRequestState> emit) {

      try{
        _repository.handoverRequest(event.orgID, event.petID, event.reason, event.desc);
        emit(HandoverRequestSuccess());
      }
      catch(error) {
        emit(HandoverRequestFail(error.toString()));
      }

    }
  }
