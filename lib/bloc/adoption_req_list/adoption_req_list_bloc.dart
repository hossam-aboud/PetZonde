import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petzone/model/adoption_post.dart';
import 'package:petzone/repositories/data_repository.dart';
import 'package:petzone/repositories/org_repository.dart';

part 'adoption_req_list_event.dart';
part 'adoption_req_list_state.dart';

class AdoptionReqListBloc extends Bloc<AdoptionReqListEvent, AdoptionReqListState> {
  final DataRepository _repository= DataRepository();
  AdoptionReqListState get initialState => AdoptionReqListInitial();
  AdoptionReqListBloc() : super(AdoptionReqListInitial()) {
    on<LoadRequestPostEvent>(_LoadRequestPostEvents);
  }

  Future<void> _LoadRequestPostEvents(LoadRequestPostEvent event, Emitter<AdoptionReqListState> emit) async {
    emit(AdoptionReqListLoading());
    try{
      final snapshot = await _repository.getOrgAdoptionPosts();

      List<adoptionPost> list = [];
        for (var doc in snapshot.docs) {
          adoptionPost a = adoptionPost.fromSnapshot(doc.data() as Map<String, dynamic>);
          list.add(a);
        }
        emit(AdoptionReqListLoaded(posts: list));

    }
    catch(e){
      emit(AdoptionReqListFail(message: e.toString()));
    }

  }
}
