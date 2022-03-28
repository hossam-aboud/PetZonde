import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pl_vet_request_list_event.dart';
part 'pl_vet_request_list_state.dart';

class PlVetRequestListBloc
    extends Bloc<PlVetRequestListEvent, PlVetRequestListState> {
  PlVetRequestListBloc() : super(PlVetRequestInitial()) {
    on<LoadRequests>(_loadRequest);
    on<CancelRequest>(_cancelRequest);
  }

  FutureOr<void> _loadRequest(
      LoadRequests event, Emitter<PlVetRequestListState> emit) {
    emit(PlVetRequestLoading());
    try {
      // fetch from database
      emit(PlVetRequestLoaded());
    } catch (error) {
      emit(PlVetRequestFail(error.toString()));
    }
  }

  FutureOr<void> _cancelRequest(
      CancelRequest event, Emitter<PlVetRequestListState> emit) {
    try {
      // do in the database
      emit(PlVetRequestCanceled());
    } catch (error) {
      emit(PlVetRequestCancelFail(error.toString()));
    }
  }
}
