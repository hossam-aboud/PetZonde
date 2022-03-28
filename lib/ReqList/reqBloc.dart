import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../model/adoption_post.dart';
import 'Repository.dart';
import 'package:petzone/repositories/storage.dart';

part 'reqStates.dart';
part 'reqEvent.dart';

class PLReqAdoptionBloc extends Bloc<PLReqAdoptionEvent, PLReqAdoptionState> {
  final Repository _repository;
  final _picker = ImagePicker();
   final Storage storage = Storage();

  PLReqAdoptionBloc({required Repository repository})
      : _repository = repository,
        super(PLReqAdoptionInitial()) {
       on<DisplayReq>(_onGetData);
       on<CancelReq>(_onCancelReq);

  }

  Future<void> _onGetData(DisplayReq event, Emitter<PLReqAdoptionState> emit) async {
    emit(PLReqAdoptionLoading());
    try {
      final snapshot = await _repository.getOrgAdoptionPostsReq();
      List<adoptionPost> adoptionReq = [];
      for(var doc in snapshot.docs){
        String status = doc['status'];
        String id = doc['requestID'];
        final getPost = await _repository.getAdoptionPost(doc['postID']);
        adoptionPost post = adoptionPost.fromSnapshot(getPost.data() as Map<String, dynamic>, status: status, reqID: id);
        adoptionReq.add(post);
      }
      emit(PLReqAdoptionSuccess(posts: adoptionReq));
    } catch (error) {
      print('error: $error');
      emit(PLReqAdoptionFail(message: error.toString()));
    }
  }


  Future<FutureOr<void>> _onCancelReq(CancelReq event, Emitter<PLReqAdoptionState> emit) async {

    await _repository.cancelReq(event.postID, event.reqID)
          .then((value) => emit(PLReqAdoptionCanceled()))
          .catchError((error){emit(PLReqAdoptionCancelFail());});
  }
}