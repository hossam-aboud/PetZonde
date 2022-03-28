import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petzone/repositories/data_repository.dart';

import '../../model/poster.dart';

part 'handovering_list_event.dart';
part 'handovering_list_state.dart';

class HandoveringListBloc extends Bloc<HandoveringListEvent, HandoveringListState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DataRepository _dataRepository = DataRepository();
  HandoveringListBloc() : super(HandoveringListInitial()) {
on<LoadHandoveringList>(_LoadHandoveringList);
  }

  Future<FutureOr<void>> _LoadHandoveringList(LoadHandoveringList event, Emitter<HandoveringListState> emit) async {
    emit(HandoveringListLoading());
    try{
      String uid = _firebaseAuth.currentUser!.uid;
      List<Poster> orgList = [];
      DocumentSnapshot pl = await _dataRepository.getPetLoverProfile(uid);
      final snapshot = await _dataRepository.getOrgList(pl['city']);

      for (var doc in snapshot.docs) {
        Poster a = Poster.fromOrgSnapshot(doc.data() as Map<String, dynamic>);
        orgList.add(a);
      }

      emit(HandoveringListLoaded(orgList));
    }

    catch(e){
      emit(HandoveringListFail(e.toString()));
    }
  }
}
