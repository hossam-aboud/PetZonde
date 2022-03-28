import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:petzone/model/PetLover.dart';
import 'package:petzone/model/adoption_post.dart';
import 'package:petzone/model/adoption_request.dart';
import 'package:petzone/repositories/decision_repository.dart';
import 'package:petzone/repositories/request_repository.dart';
part 'adopt_decision_event.dart';
part 'adopt_decision_state.dart';

class AdoptDecisionBloc extends Bloc<AdoptDecisionEvent, AdoptDecisionState> {
  final DecisionRepository decisionRepository;

  AdoptDecisionBloc({required this.decisionRepository}) : super(Loading()) {
    on<AdoptDecisionFunction>((event, emit) async {
      emit(Loading());
      try {
        bool? result = await decisionRepository.request(
          event.status
          event.postId,
          event.requestId
            );
        if (result) {
          emit(Saved());
        }
      } catch (e) {
        emit(AdoptDecisionError(e.toString()));
      }
    });

    on<AdoptDecisionInit>((event, emit) async {
        emit(DecisionReady(
          event.petLover,
          event.adoptionDetail,
          event.adoptionReq
        ));
    });
  }
}
