part of 'forgot_bloc.dart';

@immutable
abstract class ForgotState extends Equatable {}


class ForgotRequest extends ForgotState {
  @override
  List<Object?> get props => [];
}

class ForgotSuccess extends ForgotState {
  @override
  List<Object?> get props => [];
}

class ForgotError extends ForgotState {
  final String error;

  ForgotError(this.error);
  @override
  List<Object?> get props => [error];
}

class NoForgotRequest extends ForgotState {
  @override
  List<Object?> get props => [];
}