import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:petzone/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(UnAuthenticated()) {
    // When User Presses the SignIn Button, we will send the SignInRequested Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignInRequested>((event, emit) async {
      emit(Loading());
      try {
        UserCredential? result = await authRepository.signIn(
            email: event.email, password: event.password);
        print(["result:00000", result?.user?.uid]);
        if (result != null) {
          {
            if (event.email.endsWith('admin.com'))
              emit(Authenticated('admin', {}));

            var docSnapshot;
            await FirebaseFirestore.instance
                .collection('users')
                .where('uid', isEqualTo: result.user?.uid)
                //.doc(result.user?.uid)
                .get()
                .then((value) => docSnapshot = value.docs.first);

            if (docSnapshot.exists) {
              Map<String, dynamic> data = docSnapshot.data();
              var value = data['isApproved'];
              if (value) {
                emit(Authenticated(data['role'], data));
              } else {
                emit(AuthError("This account isn't approved"));
                emit(UnAuthenticated());
              }
            } else {
              emit(AuthError("This account isn't approved"));
              emit(UnAuthenticated());
            }
          }
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });
    on<SignOutRequested>((event, emit) async {
      emit(UnAuthenticated());
    });
    // When User Presses the SignUp Button, we will send the SignUpRequest Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
  }

/*
    on<SignUpRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.signUp(
            email: event.email, password: event.password);
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });
    // When User Presses the SignOut Button, we will send the SignOutRequested Event to the AuthBloc to handle it and emit the UnAuthenticated State
    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      await authRepository.signOut();
      emit(UnAuthenticated());
    });
  }
}
 */
}
