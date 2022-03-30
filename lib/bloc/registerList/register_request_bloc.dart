import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/UserRegister.dart';

import '../../repositories/admin_repository.dart';

part 'register_request_event.dart';

part 'register_request_state.dart';

class RegisterRequestBloc
    extends Bloc<RegisterRequestEvent, RegisterRequestState> {
  final AdminRepository _adminRepository;

  StreamSubscription? _subscription;

  RegisterRequestBloc({required AdminRepository adminRepository})
      : _adminRepository = adminRepository,
        super(LoadingState()) {
    on<UpdateListEvent>(_onUpdateListEvent);
    on<GetListEvent>(_onGetListEvent);
  }

  static RegisterRequestBloc get(context) => BlocProvider.of(context);

  void _onUpdateListEvent(
      UpdateListEvent event, Emitter<RegisterRequestState> emit) {
    emit(LoadingState());
    _subscription?.cancel;
    _subscription =
        _adminRepository.getRegisterRequestList(event.tag).listen((reqs) {
      add(GetListEvent(event.tag, requestList: reqs));
    });
  }

  void _onGetListEvent(GetListEvent event, Emitter<RegisterRequestState> emit) {
    emit(LoadedState(event.tag, requestList: event.requestList));
  }

  getAllUsersApproved() {
    FirebaseFirestore.instance.collection('users').get().then(
          (value) {},
          onError: (error) {},
        );
  }
}
