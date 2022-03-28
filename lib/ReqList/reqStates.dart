part of 'reqBloc.dart';

abstract class PLReqAdoptionState extends Equatable {
  const PLReqAdoptionState();
  @override
  List<Object> get props => [];
}

class PLReqAdoptionInitial extends PLReqAdoptionState {
  @override
  List<Object> get props => [];
}

class PLReqAdoptionLoading extends PLReqAdoptionState {
  @override
  List<Object> get props => [];
}

class PLReqAdoptionSuccess extends PLReqAdoptionState {
  final  List<adoptionPost> posts;

  const PLReqAdoptionSuccess({required this.posts});
  @override
  List<Object> get props => [posts];
}

class PLReqAdoptionFail extends PLReqAdoptionState {
  String message;

  PLReqAdoptionFail({required this.message});
  @override
  List<Object> get props => [message];
}

class PLReqAdoptionCanceled extends PLReqAdoptionState {
  @override
  List<Object> get props => [];
}

class PLReqAdoptionCancelFail extends PLReqAdoptionState {
  @override
  List<Object> get props => [];
}
