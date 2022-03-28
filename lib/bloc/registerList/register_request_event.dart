part of 'register_request_bloc.dart';

abstract class RegisterRequestEvent extends Equatable {
  const RegisterRequestEvent();
  @override
  List<Object> get props => [];
}


class UpdateListEvent extends RegisterRequestEvent {
  final String tag;
UpdateListEvent(this.tag);
  @override
  List<Object> get props => [tag];

}

class GetListEvent extends RegisterRequestEvent {
  final List<Future<User?>> requestList;
  final String tag;
  GetListEvent(this.tag, {required this.requestList});
  @override
  List<Object> get props => [requestList, tag];

}
