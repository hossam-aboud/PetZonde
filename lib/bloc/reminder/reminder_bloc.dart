import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import '../../model/Pet.dart';
import '../../repositories/pet_lover_repository.dart';
import '../../repositories/request_repository.dart';
import '../../service/local_notifaction_service.dart';

part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  PetLoverRepository _repository = PetLoverRepository();
  ReminderBloc() : super(ReminderInitial()) {
    on<AddReminder>(_AddReminder);
    on<LoadPets>(_onLoad);

  }

  Future<FutureOr<void>> _onLoad(LoadPets event, Emitter<ReminderState> emit) async {
    try{
      final petSnapshot = await RequestRepository().getPets();

      List<Pet> petList = [];
      for(var doc in petSnapshot.docs){
        Pet pet = Pet.fromSnapshot(doc.data() as  Map<String, dynamic>);
        petList.add(pet);
      }
      emit(ReminderPetLoad(petList));}

    catch(error){
      emit(ReminderFail(error.toString()));
    }

  }


  Future<FutureOr<void>> _AddReminder(AddReminder event, Emitter<ReminderState> emit) async {
    emit(ReminderSubmitting());
    try{
      String date = DateFormat('MMMM d, y kk:mm').format(event.date);
      print(date);
     await _repository.addReminder(event.petID, event.title, event.description, date, event.repeat);
     await NotificationService.showScheduledNotifaction(id: event.petID.hashCode, title: event.title, body: event.description,
                                                        dateTime: event.date, repeatTag: event.repeat);
     emit(ReminderSuccess());
    }
    catch(error){
      emit(ReminderFail(error.toString()));
    }

  }
}
