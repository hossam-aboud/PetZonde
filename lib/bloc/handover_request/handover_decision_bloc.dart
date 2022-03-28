import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/decision_repository.dart';

part 'handover_decision_event.dart';
part 'handover_decision_state.dart';

class HandoverDecisionBloc extends Bloc<HandoverDecisionEvent, HandoverDecisionState> {
  DecisionRepository _decisionRepository = DecisionRepository();
  HandoverDecisionBloc() : super(HandoverDecisionInitial()) {
    on<DecideHandover>(_DecideHandover);
  }

  Future<FutureOr<void>> _DecideHandover(DecideHandover event, Emitter<HandoverDecisionState> emit) async {
    emit(HandoverDecisionLoading());

    try{
      await _decisionRepository.handoverDecision(event.status, event.requestID);
      emit(HandoverDecisionChanged());
    }

    catch(error){
      log(error.toString());
      emit(HandoverDecisionError(error.toString()));
    }

  }
}
