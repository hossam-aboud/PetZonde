part of 'adopt_decision_bloc.dart';

@immutable
abstract class AdoptDecisionState extends Equatable {}

class Loading extends AdoptDecisionState {
  @override
  List<Object?> get props => [];
}

class Saved extends AdoptDecisionState {
  @override
  List<Object> get props => [];
}

class DecisionReady extends AdoptDecisionState {
  final PetLover petLover;
  final adoptionPost adoptionDetail;
  final adoptionRequest adoptionReq;
  DecisionReady(this.petLover,this.adoptionDetail,this.adoptionReq);
  @override
  List<Object> get props => [petLover,adoptionDetail,adoptionReq];
}

// If any error occurs the state is changed to AuthError.
class AdoptDecisionError extends AdoptDecisionState {
  final String error;

  AdoptDecisionError(this.error);
  @override
  List<Object?> get props => [error];
}
