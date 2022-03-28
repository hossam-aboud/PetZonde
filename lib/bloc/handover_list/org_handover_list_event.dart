part of 'org_handover_list_bloc.dart';

abstract class OrgHandoverListEvent extends Equatable {
  const OrgHandoverListEvent();
}


class LoadRequestsEvent extends OrgHandoverListEvent{

  const LoadRequestsEvent();

  @override
  List<Object> get props => [];
}

class LoadPetLoverRequests extends OrgHandoverListEvent{

  const LoadPetLoverRequests();

  @override
  List<Object> get props => [];
}

class CancelPetLoverRequest extends OrgHandoverListEvent{
final String requestID;
  const CancelPetLoverRequest(this.requestID);

  @override
  List<Object> get props => [requestID];
}

