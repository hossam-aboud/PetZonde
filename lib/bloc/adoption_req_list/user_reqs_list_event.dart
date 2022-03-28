part of 'user_reqs_list_bloc.dart';

abstract class UserReqsListEvent extends Equatable {
  const UserReqsListEvent();
  @override
  List<Object> get props => [];
}
class LoadUserReqsListEvent extends UserReqsListEvent{
  final String postID;

  LoadUserReqsListEvent(this.postID);
  @override
  List<Object> get props => [postID];
}