import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petzone/Profiles/profile_edit_UI.dart';
import 'package:petzone/model/PetLover.dart';
import 'package:petzone/repositories/org_repository.dart';

import '../../model/Pet.dart';
import '../../model/handover_request.dart';
import '../../model/poster.dart';

part 'org_handover_list_event.dart';
part 'org_handover_list_state.dart';

class HandoverListBloc extends Bloc<OrgHandoverListEvent, HandoverListState> {
  OrgRepository _orgRepository = OrgRepository();
  HandoverListBloc() : super(HandoverListInitial()) {
    on<LoadRequestsEvent>(_LoadRequests);
    on<LoadPetLoverRequests>(_LoadPetLoverRequests);
    on<CancelPetLoverRequest>(_CancelRequest);
  }

  Future<FutureOr<void>> _LoadRequests(LoadRequestsEvent event, Emitter<HandoverListState> emit) async {
    emit(HandoverListLoading());
    try{
      List<Handover> requestList = [];
      final reqSnaphot = await _orgRepository.getHandoverRequests();
      for(var req in reqSnaphot.docs){
        var plSnapshot = await  _orgRepository.getPetLoverProfile(req['uid']);
        var petSnapshot = await _orgRepository.getPetProfile(req['petID']);
        PetLover petLover = PetLover.fromSnapshot(plSnapshot.data() as Map<String, dynamic>);
        Pet pet = Pet.fromSnapshot(petSnapshot.data() as Map<String, dynamic>);

        Handover request = Handover.fromSnapshot(req.data() as Map<String, dynamic>, pet, pl: petLover);

        requestList.add(request);
      }
      emit(HandoverListSuccess(requestList));
    }
    catch(error){
      emit(HandoverListFail(error.toString()));
    }

  }

  Future<FutureOr<void>> _LoadPetLoverRequests(LoadPetLoverRequests event, Emitter<HandoverListState> emit) async {
    emit(HandoverListLoading());
    try{
      List<Handover> requestList = [];
      final reqSnaphot = await _orgRepository.getPetLoverHandoverRequests();
      for(var req in reqSnaphot.docs){
        var orgSnapshot = await  _orgRepository.getOrgProfile(req['orgID']);
        Poster org = Poster.fromOrgSnapshot(orgSnapshot.data() as Map<String, dynamic>);
        var petSnapshot = await _orgRepository.getPetProfile(req['petID']);
        Pet pet = Pet.fromSnapshot(petSnapshot.data() as Map<String, dynamic>);

        Handover request = Handover.fromSnapshot(req.data() as Map<String, dynamic>, pet, user: org);

        requestList.add(request);
      }
      emit(HandoverListSuccess(requestList));
    }
    catch(error){
      emit(HandoverListFail(error.toString()));
    }

  }




  Future<FutureOr<void>> _CancelRequest(CancelPetLoverRequest event, Emitter<HandoverListState> emit) async {
    try{
      await _orgRepository.cancelHandover(event.requestID);
      emit(HandoverCanceled());
    }
    catch(error){
      emit(HandoverCancelFail());

    }

  }
}
