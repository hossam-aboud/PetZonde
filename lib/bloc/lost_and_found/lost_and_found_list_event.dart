part of 'lost_and_found_list_bloc.dart';

abstract class LostAndFoundListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadLostAndFoundList extends LostAndFoundListEvent {
  final LatLng currentLocation;
   LoadLostAndFoundList(this.currentLocation);

  @override
  List<Object> get props => [currentLocation];
}


class LoadMyLostAndFoundList extends LostAndFoundListEvent {
  LoadMyLostAndFoundList();

  @override
  List<Object> get props => [];
}

