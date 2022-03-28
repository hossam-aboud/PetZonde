part of 'adoption_req_list_bloc.dart';

abstract class AdoptionReqListEvent extends Equatable {
  const AdoptionReqListEvent();
  @override
  List<Object> get props => [];
}

class LoadRequestPostEvent extends AdoptionReqListEvent{

  const LoadRequestPostEvent();

  @override
  List<Object> get props => [];
}