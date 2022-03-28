part of 'register_profile_bloc.dart';

@immutable
abstract class RegisterProfileEvent {
  List<Object> get props => [];
}

class LoadProfileEvent extends RegisterProfileEvent {

}

class UpdateProfileEvent extends RegisterProfileEvent {

}


class ApproveUserEvent extends RegisterProfileEvent{
  final User user;

  ApproveUserEvent(this.user);
  @override
  List<Object> get props => [user];

}

class DisapproveUserEvent extends RegisterProfileEvent{
  final User user;

  DisapproveUserEvent(this.user);
  @override
  List<Object> get props => [user];
}