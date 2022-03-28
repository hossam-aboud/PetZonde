part of 'adopt_req_bloc.dart';

@immutable
abstract class AdoptRequestState extends Equatable {}

class Loading extends AdoptRequestState {
  @override
  List<Object?> get props => [];
}

class Saved extends AdoptRequestState {
  @override
  List<Object> get props => [];
}

class Normal extends AdoptRequestState {
  @override
  List<Object> get props => [];
}

// If any error occurs the state is changed to AuthError.
class AdoptRequestError extends AdoptRequestState {
  final String error;

  AdoptRequestError(this.error);
  @override
  List<Object?> get props => [error];
}
