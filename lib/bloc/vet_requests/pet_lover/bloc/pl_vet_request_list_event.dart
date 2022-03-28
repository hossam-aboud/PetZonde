part of 'pl_vet_request_list_bloc.dart';

abstract class PlVetRequestListEvent extends Equatable {
  const PlVetRequestListEvent();

  @override
  List<Object> get props => [];
}

class LoadRequests extends PlVetRequestListEvent {
  @override
  List<Object> get props => [];
}

class CancelRequest extends PlVetRequestListEvent {
  final String requestID;

  CancelRequest(this.requestID);
  @override
  List<Object> get props => [requestID];
}
