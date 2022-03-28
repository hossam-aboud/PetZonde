part of 'register_profile_bloc.dart';

@immutable
abstract class RegisterProfileState {}

class LoadingState extends RegisterProfileState {}


class LoadedState extends RegisterProfileState {

}

class UpdatedState extends RegisterProfileState {
  final String status;

  UpdatedState(this.status);

  @override
  List<Object> get props => [status];
}