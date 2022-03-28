part of 'lost_and_found_list_bloc.dart';

abstract class LostAndFoundListState extends Equatable {
  @override
  List<Object> get props => [];
}

class LostAndFoundListInitial extends LostAndFoundListState {
  @override
  List<Object> get props => [];
}

class LostAndFoundListLoading extends LostAndFoundListState {
  @override
  List<Object> get props => [];
}

class LostAndFoundListSuccess extends LostAndFoundListState {
  final List<lostAndFoundPost> docs;

  LostAndFoundListSuccess({required this.docs});

  @override
  List<Object> get props => [docs];
}

class LostAndFoundListFail extends LostAndFoundListState {
  String message;
  LostAndFoundListFail({required this.message});
}