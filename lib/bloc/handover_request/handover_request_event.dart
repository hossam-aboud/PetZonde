part of 'handover_request_bloc.dart';

abstract class HandoverRequestEvent extends Equatable {
  const HandoverRequestEvent();
  @override
  List<Object> get props => [];
}

class LoadPets extends HandoverRequestEvent {
  LoadPets();
@override
List<Object> get props => [];
}


class  SubmitHandoverRequest extends HandoverRequestEvent {
  final String orgID, petID, reason, desc;
  SubmitHandoverRequest(this.orgID, this.petID, this.reason, this.desc);
  @override
  List<Object> get props => [orgID, petID, reason, desc];
}