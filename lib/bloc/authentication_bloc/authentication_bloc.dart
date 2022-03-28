import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/repositories/user_repository.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(AuthenticationInitial()){
    on<AuthenticationStarted>(_mapAuthenticationStartedToState);
    on<AuthenticationLoggedIn>(_mapAuthenticationLoggedInToState);
    on<AuthenticationLoggedOut>(_mapAuthenticationLoggedOutInToState);
  }

  //AuthenticationLoggedOut
  void _mapAuthenticationLoggedOutInToState(AuthenticationLoggedOut event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationFailure());
    _userRepository.signOut();
  }

  //AuthenticationLoggedIn
  void _mapAuthenticationLoggedInToState(AuthenticationLoggedIn event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationSuccess(await _userRepository.getUser()));
  }

  //AuthenticationStarted
  void _mapAuthenticationStartedToState(AuthenticationStarted event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationFailure());
    final isSignedIn = await _userRepository.isSignedIn();
    if (isSignedIn) {
      final firebaseUser = await _userRepository.getUser();
      emit(AuthenticationSuccess(firebaseUser));
    } else {
      emit(AuthenticationFailure());
    }
  }

/*@override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStartedToState();
    } else if (event is AuthenticationLoggedIn) {
      yield* _mapAuthenticationLoggedInToState();
    } else if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLoggedOutInToState();
    }
  }*/

  /*//AuthenticationLoggedIn
  Stream<AuthenticationState> _mapAuthenticationLoggedInToState() async* {
    yield AuthenticationSuccess(await _userRepository.getUser());
  }

  // AuthenticationStarted
  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    final isSignedIn = await _userRepository.isSignedIn();
    if (isSignedIn) {
      final firebaseUser = await _userRepository.getUser();
      yield AuthenticationSuccess(firebaseUser);
    } else {
      yield AuthenticationFailure();
    }
  }*/
}