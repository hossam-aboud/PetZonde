import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petzone/Screens/homepage/home_page.dart';
import 'package:petzone/Screens/lost_and_found/posts_map_view.dart';
import 'package:petzone/model/lost_and_found.dart';
import 'package:petzone/widgets/profile.dart';

import '../../bloc/lost_and_found/lost_and_found_list_bloc.dart';
import '../../constants.dart';
import '../../widgets/lfpost_widget.dart';
import 'lost_and_found_add.dart';
import 'lost_and_found_details.dart';
import 'my_lost_and_found_list.dart';

class lostAndFoundList extends StatefulWidget {
  @override
  createState() => _lostAndFoundListState();
}

class _lostAndFoundListState extends State<lostAndFoundList> {
  List<lostAndFoundPost>? posts;
  LatLng? currentLatLng;
  LostAndFoundListBloc? _lostBloc;
  late GoogleMapController mapController;
  bool _isLoadingForFirstTime = true;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future locatePosition() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentLatLng = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  initState() {
    super.initState();
    //_lostBloc = BlocProvider.of<LostAndFoundListBloc>(context);
    locatePosition().whenComplete(() {
      //  _lostBloc!.add(LoadLostAndFoundList(currentLatLng!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Lost And Found Posts",
            style: TextStyle(
              color: Colors.teal[800],
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => homePage(),
                  ));
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.teal[800],
            ),
          ),
        ),
        body: Column(
          children: [
            CustomTabBar(
              tabs: [Tab(text: 'All Posts'), Tab(text: 'My Posts')],
              tabView: [
                currentLatLng == null
                    ? Center(child: CircularProgressIndicator())
                    : BlocProvider<LostAndFoundListBloc>(
                        create: (context) => LostAndFoundListBloc()
                          ..add(LoadLostAndFoundList(currentLatLng!)),
                        child: Container(
                          child: BlocBuilder<LostAndFoundListBloc,
                              LostAndFoundListState>(builder: (context, state) {
                            if (state is LostAndFoundListInitial) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is LostAndFoundListLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is LostAndFoundListSuccess) {
                              posts = state.docs;

                              if (posts!.isEmpty) {
                                return Center(
                                    child: Text(
                                        "No Nearby Lost and Found posts",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5));
                              }

                              return Padding(
                                padding: const EdgeInsets.fromLTRB(9, 16, 9, 9),
                                child: Center(
                                  child: GridView.count(
                                    childAspectRatio: 0.8,
                                    crossAxisCount: 2,
                                    children: List.generate(state.docs.length,
                                        (index) {
                                      lostAndFoundPost p = state.docs[index];
                                      return lostAndFoundWidget(
                                          pet: p,
                                          nextPage:
                                              lostAndFoundDetails(pet: p));
                                    }),
                                  ),
                                ),
                              );
                            } else if (state is LostAndFoundListFail) {
                              return Center(
                                child: Text(state.message),
                              );
                            } else {
                              return Center(
                                  child: Text("something went wrong"));
                            }
                          }),
                        )),
                MyLostAndFoundList()
              ],
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              isExtended: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => addLostAndFound()),
                );
              },
              icon: const Icon(Icons.add),
              label: Text('Add Post'),
              backgroundColor: PrimaryButton,
            ),
            SizedBox(height: 5),
            FloatingActionButton.extended(
              onPressed: () {
                if (posts != null && currentLatLng != null)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => lostAndFoundMap(
                              posts: posts!,
                              currentLatLng: currentLatLng!,
                            )),
                  );
              },
              icon: const Icon(Icons.share_location),
              label: Text('Map View'),
              backgroundColor: PrimaryButton,
            ),
          ],
        ));
  }

  Widget AllList() {
    return BlocProvider<LostAndFoundListBloc>(
      create: (context) =>
          LostAndFoundListBloc()..add(LoadLostAndFoundList(currentLatLng!)),
      child: BlocBuilder<LostAndFoundListBloc, LostAndFoundListState>(
          builder: (context, state) {
        if (state is LostAndFoundListInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LostAndFoundListLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LostAndFoundListSuccess) {
          posts = state.docs;

          if (posts!.isEmpty) {
            return Center(child: Text('No Lost And Found Posts'));
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(9, 16, 9, 9),
            child: Center(
              child: GridView.count(
                childAspectRatio: 0.8,
                crossAxisCount: 2,
                children: List.generate(state.docs.length, (index) {
                  lostAndFoundPost p = state.docs[index];
                  return lostAndFoundWidget(
                      pet: p, nextPage: lostAndFoundDetails(pet: p));
                }),
              ),
            ),
          );
        } else if (state is LostAndFoundListFail) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return Center(child: Text("something went wrong"));
        }
      }),
    );
  }
}
