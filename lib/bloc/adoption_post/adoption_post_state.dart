part of 'adoption_post_bloc.dart';

abstract class AdoptionPostState extends Equatable {
  const AdoptionPostState();
  List<Object> get props => [];
}

class AdoptionPostInitial extends AdoptionPostState {
  @override
  List<Object> get props => [];
}

class SubmitAdoptionPostLoading extends AdoptionPostState {
  @override
  List<Object> get props => [];
}

class SubmitAdoptionPostSuccess extends AdoptionPostState {
  @override
  List<Object> get props => [];
}

class SubmitAdoptionPostFail extends AdoptionPostState {
  final String error;

  const SubmitAdoptionPostFail({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SubmitAdoptionPostFail { error: $error }';
}