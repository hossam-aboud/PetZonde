part of 'forgot_bloc.dart';

abstract class ForgotEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class ForgotPassword extends ForgotEvent {
  final String email;

  ForgotPassword(this.email);
}