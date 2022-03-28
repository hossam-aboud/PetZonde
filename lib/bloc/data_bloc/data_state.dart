part of 'data_bloc.dart';

abstract class DataState extends Equatable {

  @override
  List<Object> get props => [];
}

class DataInitialState extends DataState {
  @override
  List<Object> get props => [];
}

class DataStateLoading extends DataState {
  @override
  List<Object> get props => [];
}

class DataStateEmpty extends DataState {
  @override
  List<Object> get props => [];
}

class DataStateLoadSuccess extends DataState {
  final List<adoptionPost> docs;

  DataStateLoadSuccess({required this.docs});

  @override
  List<Object> get props => [docs];
}

class DataErrorState extends DataState {
  String message;
  DataErrorState({required this.message});
}