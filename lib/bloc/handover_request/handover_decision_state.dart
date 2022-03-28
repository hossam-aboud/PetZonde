part of 'handover_decision_bloc.dart';

abstract class HandoverDecisionState extends Equatable {
  const HandoverDecisionState();
}

class HandoverDecisionInitial extends HandoverDecisionState {
  @override
  List<Object> get props => [];
}

class HandoverDecisionChanged extends HandoverDecisionState {
  @override
  List<Object> get props => [];
}


class HandoverDecisionLoading extends HandoverDecisionState {
  @override
  List<Object> get props => [];
}


class HandoverDecisionError extends HandoverDecisionState {
  final String error;

  HandoverDecisionError(this.error);

  @override
  List<Object> get props => [error];
}