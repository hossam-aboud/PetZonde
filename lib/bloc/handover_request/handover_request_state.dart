part of 'handover_request_bloc.dart';

abstract class HandoverRequestState extends Equatable {
  const HandoverRequestState();
}

class HandoverRequestInitial extends HandoverRequestState {
  @override
  List<Object> get props => [];
}

class HandoverRequestEmpty extends HandoverRequestState {
  @override
  List<Object> get props => [];
}

class HandoverRequestLoaded extends HandoverRequestState {
  final List<Pet> petList;

  HandoverRequestLoaded(this.petList);

  @override
  List<Object> get props => [];
}

class HandoverRequestSuccess extends HandoverRequestState {
  @override
  List<Object> get props => [];
}

class HandoverRequestFail extends HandoverRequestState {
  final String error;

  HandoverRequestFail(this.error);
  @override
  List<Object> get props => [];
}
