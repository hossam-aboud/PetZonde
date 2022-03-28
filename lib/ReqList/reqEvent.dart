part of 'reqBloc.dart';

abstract class PLReqAdoptionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DisplayReq extends PLReqAdoptionEvent {
  DisplayReq();

  }

class CancelReq extends PLReqAdoptionEvent {
  final String postID;
  final String reqID;
  CancelReq(this.reqID, this.postID);
  @override
  List<Object> get props => [postID, reqID];
}
