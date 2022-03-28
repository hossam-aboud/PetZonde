part of 'pl_vet_request_list_bloc.dart';

abstract class PlVetRequestListState extends Equatable {
  const PlVetRequestListState();
  
  @override
  List<Object> get props => [];
}

class PlVetRequestInitial extends PlVetRequestListState {
  @override
  List<Object> get props => [];
}

class PlVetRequestLoading extends PlVetRequestListState {
  @override
  List<Object> get props => [];
}

class PlVetRequestLoaded extends PlVetRequestListState {
  /* To be added: List of vet requests.
  final List<Consult> reqList;

  const PlVetRequestLoaded(this.reqList);
  */
  @override
  List<Object> get props => [];
}

class PlVetRequestFail extends PlVetRequestListState {
 final String message;

  const PlVetRequestFail(this.message);

  @override
  List<Object> get props => [message];
}

class PlVetRequestCanceled extends PlVetRequestListState {
  @override
  List<Object> get props => [];
}

class PlVetRequestCancelFail extends PlVetRequestListState {
 final String message;

  const PlVetRequestCancelFail(this.message);

  @override
  List<Object> get props => [message];
}
