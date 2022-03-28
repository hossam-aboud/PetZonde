part of 'user_reqs_list_bloc.dart';

abstract class UserReqsListState extends Equatable {
  const UserReqsListState();
  @override
  List<Object> get props => [];
}

class UserReqsListInitial extends UserReqsListState {
  @override
  List<Object> get props => [];
}

class UserReqsListLoading extends UserReqsListState {
  @override
  List<Object> get props => [];
}

class UserReqsListLoaded extends UserReqsListState {
 final List<adoptionRequest> userRequests;
 UserReqsListLoaded({required this.userRequests});
  @override
  List<Object> get props => [userRequests];
}

class UserReqsListFail extends UserReqsListState {
  String message;

  UserReqsListFail({required this.message});
  @override
  List<Object> get props => [message];
}