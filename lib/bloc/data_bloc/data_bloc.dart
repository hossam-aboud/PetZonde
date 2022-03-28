//This bloc is used for fetching data

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/model/adoption_post.dart';
import 'package:petzone/repositories/data_repository.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {

  final DataRepository _repository;

  DataBloc({required DataRepository DataRepository})
      : _repository = DataRepository,
        super(DataStateLoading()) {
    on<PetloverAdoptionPostEventLoad>(_PetloverAdoptionPostEventLoad);
    on<OrgAdoptionPostEventLoad>(_OrgAdoptionPostEventLoad);
  }

  DataState get initialState => DataInitialState();

  Future<void> _PetloverAdoptionPostEventLoad(PetloverAdoptionPostEventLoad event, Emitter<DataState> emit) async{
    emit(DataStateLoading());

    try{
      final snapshot = await _repository.getAdoptionPosts();
      bool isEmpty = await snapshot.docs.isEmpty;

      if(isEmpty){
        emit(DataStateEmpty());
      }else{
        List<adoptionPost> list = [];
        for (var doc in snapshot.docs) {
          adoptionPost a = adoptionPost.fromSnapshot(doc.data() as Map<String, dynamic>);
          list.add(a);
        }
        emit(DataStateLoadSuccess(docs: list));}

    }
    catch(e){
      emit(DataErrorState(message: e.toString()));
    }
  }

  Future<void> _OrgAdoptionPostEventLoad(OrgAdoptionPostEventLoad event, Emitter<DataState> emit) async{
    emit(DataStateLoading());

    try{
      final snapshot = await _repository.getOrgAdoptionPosts();
      bool isEmpty = await snapshot.docs.isEmpty;

      if(isEmpty){
        emit(DataStateEmpty());
      }else{
        List<adoptionPost> list = [];
        for (var doc in snapshot.docs) {
          adoptionPost a = adoptionPost.fromSnapshot(doc.data() as Map<String, dynamic>);
          list.add(a);
        }
        emit(DataStateLoadSuccess(docs: list));}

    }
    catch(e){
      emit(DataErrorState(message: e.toString()));
    }
  }

}