part of 'lost_and_found_add_bloc.dart';

abstract class LostAndFoundAddState extends Equatable {
  const LostAndFoundAddState();
}

class LostAndFoundAddInitial extends LostAndFoundAddState {
  @override
  List<Object> get props => [];
}

class LostAndFoundAddLoading extends LostAndFoundAddState {
  @override
  List<Object> get props => [];
}

class LostAndFoundAddSuccess extends LostAndFoundAddState {
  @override
  List<Object> get props => [];
}

class LostAndFoundAddFail extends LostAndFoundAddState {
  final String error;

  const LostAndFoundAddFail({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Submit Lost And Found Post Fail { error: $error }';
}