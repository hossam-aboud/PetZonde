part of 'reminder_bloc.dart';

abstract class ReminderState extends Equatable {
  const ReminderState();
}

class ReminderInitial extends ReminderState {
  @override
  List<Object> get props => [];
}

class ReminderSubmitting extends ReminderState {
  @override
  List<Object> get props => [];
}

class ReminderSuccess extends ReminderState {
  @override
  List<Object> get props => [];
}

class ReminderFail extends ReminderState {
  final String error;

  ReminderFail(this.error);
  @override
  List<Object> get props => [error];
}

class ReminderPetLoad extends ReminderState {
  final List<Pet> petList;
  ReminderPetLoad(this.petList);

  @override
  List<Object> get props => [petList];
}