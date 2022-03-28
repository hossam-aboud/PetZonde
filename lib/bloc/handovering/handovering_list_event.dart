part of 'handovering_list_bloc.dart';

abstract class HandoveringListEvent extends Equatable {
  const HandoveringListEvent();
  @override
  List<Object> get props => [];
}

 class LoadHandoveringList extends HandoveringListEvent {

  const LoadHandoveringList();
  @override
  List<Object> get props => [];
}
