part of 'org_handover_list_bloc.dart';

abstract class HandoverListState extends Equatable {
  const HandoverListState();
}

class HandoverListInitial extends HandoverListState {
  @override
  List<Object> get props => [];
}

class HandoverListLoading extends HandoverListState {
  @override
  List<Object> get props => [];
}

class HandoverListSuccess extends HandoverListState {
 final List<Handover> request;
  HandoverListSuccess(this.request);
  @override
  List<Object> get props => [];
}

class HandoverListFail extends HandoverListState {
  final String error;

  HandoverListFail(this.error);
  @override
  List<Object> get props => [error];
}
class HandoverCanceled extends HandoverListState {
  @override
  List<Object> get props => [];
}

class HandoverCancelFail extends HandoverListState {
  @override
  List<Object> get props => [];
}
