part of 'adoption_req_list_bloc.dart';

abstract class AdoptionReqListState extends Equatable {
  const AdoptionReqListState();
  @override
  List<Object> get props => [];
}

class AdoptionReqListInitial extends AdoptionReqListState {
  @override
  List<Object> get props => [];
}

class AdoptionReqListLoading extends AdoptionReqListState {
  @override
  List<Object> get props => [];
}

class AdoptionReqListLoaded extends AdoptionReqListState {
final  List<adoptionPost> posts;

  const AdoptionReqListLoaded({required this.posts});
  @override
  List<Object> get props => [posts];
}

class AdoptionReqListFail extends AdoptionReqListState {
  String message;

   AdoptionReqListFail({required this.message});
  @override
  List<Object> get props => [message];
}