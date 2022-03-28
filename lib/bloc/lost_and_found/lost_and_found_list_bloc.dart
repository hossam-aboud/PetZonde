import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petzone/model/PetLover.dart';
import 'package:petzone/repositories/admin_repository.dart';

import '../../model/lost_and_found.dart';
import '../../model/poster.dart';
import '../../repositories/data_repository.dart';

part 'lost_and_found_list_event.dart';
part 'lost_and_found_list_state.dart';

class LostAndFoundListBloc extends Bloc<LostAndFoundListEvent, LostAndFoundListState> {
  final DataRepository _repository = DataRepository();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  LostAndFoundListBloc() : super(LostAndFoundListLoading()) {
    on<LoadLostAndFoundList>(_LoadLostAndFoundList);
    on<LoadMyLostAndFoundList>(_LoadMyList);
  }

  Future<FutureOr<void>> _LoadLostAndFoundList(LoadLostAndFoundList event, Emitter<LostAndFoundListState> emit) async {
    emit(LostAndFoundListLoading());
    try{
      String uid = await _firebaseAuth.currentUser!.uid;
      final snapshot = await _repository.getLostAndFoundPosts(uid);
      List<lostAndFoundPost> posts = [];
      List<lostAndFoundPost> allPosts = [];
      for (var doc in snapshot.docs) {
        bool isPetLover = true;
        double distance = compare(event.currentLocation, doc['location'].toString()).ceilToDouble();
        if(distance > 5000) {
          continue;
        }
        DocumentSnapshot plSnapshot; Poster? user;
        plSnapshot =  await _repository.getPetLoverProfile(doc['uid'])
        .then((value) {
          if (value.exists)
          user = Poster.fromPLSnapshot(value.data() as Map<String, dynamic>);

          else isPetLover = false;
          return value;
        });

        if(!isPetLover){
          await _repository.getOrgProfile(doc['uid'])
            .then((value) {
          user = Poster.fromOrgSnapshot(value.data() as Map<String, dynamic>);
          return value;
        });}
        lostAndFoundPost a = lostAndFoundPost.fromSnapshot(doc.data() as Map<String, dynamic>, distance: distance, user: user!);
        print(a.user==null);
        posts.add(a);
      }
      emit(LostAndFoundListSuccess(docs: posts));}

    catch(e){
    emit(LostAndFoundListFail(message: e.toString()));
  }


  }



  Future<FutureOr<void>> _LoadMyList(LoadMyLostAndFoundList event, Emitter<LostAndFoundListState> emit) async {
    emit(LostAndFoundListLoading());
    try{
      String uid = await _firebaseAuth.currentUser!.uid;
      final snapshot = await _repository.getMyLostAndFoundPosts(uid);
      List<lostAndFoundPost> posts = [];
      for (var doc in snapshot.docs) {
        lostAndFoundPost a = lostAndFoundPost.fromSnapshot(doc.data() as Map<String, dynamic>);
        posts.add(a);
      }
      emit(LostAndFoundListSuccess(docs: posts));}

    catch(e){
      emit(LostAndFoundListFail(message: e.toString()));
    }


  }


  double compare(LatLng currentLocation, String location) {
    List<String> latlng = location.substring(1, location.length-1).split(',');
    LatLng postLocation = LatLng(double.parse(latlng[0]), double.parse(latlng[1]));
  return GeolocatorPlatform.instance.distanceBetween(
        currentLocation.latitude, currentLocation.longitude,
        postLocation.latitude, postLocation.longitude);
  }
}
