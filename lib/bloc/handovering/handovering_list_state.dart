part of 'handovering_list_bloc.dart';

abstract class HandoveringListState extends Equatable {
  const HandoveringListState();
  @override
  List<Object> get props => [];
}

class HandoveringListInitial extends HandoveringListState {
  @override
  List<Object> get props => [];
}

class HandoveringListLoading extends HandoveringListState {
  @override
  List<Object> get props => [];
}

class HandoveringListLoaded extends HandoveringListState {
  final List<Poster> orgList;

  const HandoveringListLoaded(this.orgList);
  @override
  List<Object> get props => [orgList];
}

class HandoveringListFail extends HandoveringListState {
 final String message;

  const HandoveringListFail(this.message);

  @override
  List<Object> get props => [message];
}
