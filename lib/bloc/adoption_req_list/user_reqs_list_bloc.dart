import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:petzone/model/PetLover.dart';
import 'package:petzone/model/adoption_request.dart';
import 'package:petzone/repositories/org_repository.dart';

part 'user_reqs_list_event.dart';
part 'user_reqs_list_state.dart';

class UserReqsListBloc extends Bloc<UserReqsListEvent, UserReqsListState> {
  final OrgRepository _repository= OrgRepository();
  UserReqsListBloc() : super(UserReqsListInitial()) {
    on<LoadUserReqsListEvent>(_LoadUserReqsListEvent);
  }

  Future<FutureOr<void>> _LoadUserReqsListEvent(LoadUserReqsListEvent event, Emitter<UserReqsListState> emit) async {
    emit(UserReqsListLoading());
    final snapshot = await _repository.getAdoptionRequests(event.postID);
    try{
     List<adoptionRequest> requestList = [];
     for (var doc in snapshot.docs) {
       DocumentSnapshot plSnapshot =  await _repository.getPetLoverProfile(doc['petLoverID']);
       PetLover petLover = PetLover.fromSnapshot(plSnapshot.data() as Map<String, dynamic>);
       adoptionRequest a = adoptionRequest.fromSnapshot(doc.data() as Map<String, dynamic>, petLover, event.postID);
       requestList.add(a);
    }
      emit(UserReqsListLoaded(userRequests: requestList));
    }

    catch(e){
      emit(UserReqsListFail(message: e.toString()));
    }

  }
}
