import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:petzone/bloc/auth/auth_bloc.dart';
import 'package:petzone/repositories/auth_repository.dart';

part 'forgot_event.dart';
part 'forgot_state.dart';

class ForgotBloc extends Bloc<ForgotEvent, ForgotState> {
  final AuthRepository authRepository;
  ForgotBloc({required this.authRepository}) : super(NoForgotRequest()) {
    // When User Presses the SignIn Button, we will send the SignInRequested Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated

    on<ForgotPassword>((event, emit) async {
      emit(NoForgotRequest());
      try {
        await authRepository.forgotPassword(
            email: event.email);
        emit(ForgotRequest());
      } catch (e) {
        emit(ForgotError(e.toString()));
        emit(NoForgotRequest());
      }
    });
    // When User Presses the SignUp Button, we will send the SignUpRequest Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated

  }
}