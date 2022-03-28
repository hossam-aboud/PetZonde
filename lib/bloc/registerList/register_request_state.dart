part of 'register_request_bloc.dart';


abstract class RegisterRequestState extends Equatable {
  const RegisterRequestState();
  @override
  List<Object> get props => [];
}

class LoadingState extends RegisterRequestState {}

class LoadedState extends RegisterRequestState {
  List<Future<User?>> requestList;
 final String tag;
LoadedState(this.tag, {this.requestList = const <Future<User?>>[]});
  @override
  List<Object> get props => [requestList, tag];
}

