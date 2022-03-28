import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:petzone/repositories/request_repository.dart';
part 'adopt_req_event.dart';
part 'adopt_req_state.dart';

class AdoptRequestBloc extends Bloc<AdoptRequestEvent, AdoptRequestState> {
  final RequestRepository requestRepository;

  AdoptRequestBloc({required this.requestRepository}) : super(Normal()) {
    on<AdoptRequestFunction>((event, emit) async {
      emit(Loading());
      try {
        bool? result = await requestRepository.request(
            event.postId,
            anotherPet: event.anotherPet,
            isFriendly: event.isFriendly,
            hasKids: event.hasKids,
            type: event.typeValue,
            note: event.note);
        if (result) {
          emit(Saved());
        }
      } catch (e) {
        emit(AdoptRequestError(e.toString()));
        emit(Normal());
      }
    });
  }
}
