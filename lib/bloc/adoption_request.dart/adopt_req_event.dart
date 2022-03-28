part of 'adopt_req_bloc.dart';

abstract class AdoptRequestEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// When the user signing in with email and password this event is called and the [AuthRepository] is called to sign in the user
class AdoptRequestFunction extends AdoptRequestEvent {
  final String postId;
  final bool anotherPet;
  final int isFriendly;
  final bool hasKids;
  final int typeValue;
  final String note;

  AdoptRequestFunction(this.postId, this.anotherPet, this.isFriendly, this.hasKids,
      this.typeValue, this.note);
}
