part of 'reminder_bloc.dart';

abstract class ReminderEvent extends Equatable {
  const ReminderEvent();
  @override
  List<Object> get props => [];
}

class AddReminder extends ReminderEvent{
  final String petID;
  final String title;
  final String description;
  final DateTime date;
  final String repeat;

  AddReminder(this.petID, this.title, this.description, this.date, this.repeat);

  @override
  List<Object> get props => [petID, title, description, date, repeat];
}

class DeleteReminder extends ReminderEvent{
  final String reminderID;
  DeleteReminder(this.reminderID);

  @override
  List<Object> get props => [reminderID];
}

class LoadPets extends ReminderEvent{
  @override
  List<Object> get props => [];
}

