part of 'handover_decision_bloc.dart';

abstract class HandoverDecisionEvent extends Equatable {
  const HandoverDecisionEvent();
}

class DecideHandover extends HandoverDecisionEvent{
  final String requestID;
  final String status;

  DecideHandover(this.requestID, this.status);

  @override
  List<Object> get props => [requestID, status];
}