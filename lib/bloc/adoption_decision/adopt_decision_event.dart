part of 'adopt_decision_bloc.dart';

abstract class AdoptDecisionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// When the user signing in with email and password this event is called and the [AuthRepository] is called to sign in the user
class AdoptDecisionFunction extends AdoptDecisionEvent {
  final String status;
  final String postId;
  final String requestId;

  AdoptDecisionFunction(this.status,this.postId,this.requestId);
}

class AdoptDecisionInit extends AdoptDecisionEvent {
  final PetLover petLover;
  final adoptionPost adoptionDetail;
  final adoptionRequest adoptionReq;
  AdoptDecisionInit(this.petLover, this.adoptionDetail,this.adoptionReq);
}
