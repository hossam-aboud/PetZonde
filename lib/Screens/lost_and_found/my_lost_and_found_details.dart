import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:petzone/model/lost_and_found.dart';
import 'package:petzone/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/lost_and_found/lost_and_found_add_bloc.dart';
import '../../constants.dart';
import '../../widgets/custom_dialog.dart';
import 'lost_and_found_list.dart';

class MyLostAndFoundDetails extends StatelessWidget {
  final lostAndFoundPost pet;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId markId = MarkerId('0');

  List<String> latlng() {
    List<String> latlng =
        pet.location.substring(1, pet.location.length - 1).split(',');

    return latlng;
  }

  late GoogleMapController mapController;

  MyLostAndFoundDetails({required this.pet});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.teal[800],
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        Hero(
                          tag: pet.imgUrl.isEmpty
                              ? 'assets/pet_profile_picture.png'
                              : pet.imgUrl[0],
                          child: Container(
                            height: size.height * 0.4,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: pet.imgUrl.isEmpty
                                    ? AssetImage(
                                            'assets/pet_profile_picture.png')
                                        as ImageProvider
                                    : NetworkImage(pet.imgUrl[0]),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: pet.status != 'open'
                                              ? Colors.blueGrey[100]
                                              : pet.type == "Lost"
                                                  ? Colors.red[100]
                                                  : Colors.green[100],
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        child: Text(
                                          pet.type + ' Pet',
                                          style: TextStyle(
                                            color: pet.status != 'open'
                                                ? Colors.black45
                                                : pet.type == "Lost"
                                                    ? Colors.red
                                                    : Colors.blueGrey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.date_range,
                                            color: Colors.teal,
                                            size: 23,
                                          ),
                                          SizedBox(
                                            width: size.width * 0.01,
                                          ),
                                          Text(
                                            'Date: ' +
                                                DateFormat(
                                                        'dd/MM/yyyy, hh:mm a')
                                                    .format(pet.time),
                                            style: const TextStyle(
                                                color: Colors.teal,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                    ],
                                  ),
                                  if (pet.status != 'open')
                                    Icon(Icons.lock_outline)
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "Details",
                                style: TextStyle(
                                  color: Colors.teal[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Container(
                                margin:
                                    const EdgeInsets.fromLTRB(20, 5, 20, 10),
                                //padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: SingleChildScrollView(
                                  child: Text(
                                    pet.desc.isEmpty
                                        ? "No description"
                                        : pet.desc,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 17,
                                    ),
                                  ),
                                )),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "Location",
                                style: TextStyle(
                                  color: Colors.teal[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                                //padding: const EdgeInsets.symmetric(horizontal: 16),
                                height: 50,
                                child: SingleChildScrollView(
                                  child: Text(
                                    pet.address.isEmpty
                                        ? "No address"
                                        : pet.address,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 17,
                                    ),
                                  ),
                                )),
                            Center(
                              child: Container(
                                height: size.height * 0.25,
                                width: size.width * 0.9,
                                child: pet.location == null
                                    ? Center(child: CircularProgressIndicator())
                                    : GoogleMap(
                                        markers: <Marker>{
                                          Marker(
                                              markerId: markId,
                                              position: LatLng(
                                                  double.parse(latlng()[0]),
                                                  double.parse(latlng()[1])))
                                        },
                                        onMapCreated: (controller) {
                                          mapController = controller;
                                        },
                                        mapType: MapType.normal,
                                        myLocationEnabled: true,
                                        initialCameraPosition: CameraPosition(
                                            target: LatLng(
                                                double.parse(latlng()[0]),
                                                double.parse(latlng()[1])),
                                            zoom: 12.0),
                                      ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: size.height * 0.1,
                                ),
                                ButtonBar(
                                  children: [
                                    Visibility(
                                        visible: pet.status == 'open',
                                        child: Container(
                                          alignment: Alignment.center,
                                          //margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                                          child: ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                fixedSize:
                                                    Size(size.width * 0.5, 55),
                                                primary: PrimaryButton,
                                                onPrimary: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  barrierColor: Colors.black26,
                                                  context: context,
                                                  builder: (context) {
                                                    return confirm(context);
                                                  },
                                                );
                                              },
                                              icon: Icon(Icons.check_circle),
                                              label: Text(
                                                'Mark As Found',
                                                style: TextStyle(fontSize: 16),
                                              )),
                                        )),
                                    ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0.5,
                                            primary: DeclineButton),
                                        onPressed: () {
                                          showDialog(
                                            barrierColor: Colors.black26,
                                            context: context,
                                            builder: (context) {
                                              return delete(context);
                                            },
                                          );
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ));
  }

  buildPetFeature(String value, Color? color, String feature, Size size) {
    return Expanded(
      child: Container(
        height: size.height * 0.09,
        margin: EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Color.fromRGBO(226, 246, 240, 1),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              feature,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              value,
              softWrap: true,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  delete(context) {
    return CustomAlertDialog(
      title: "Delete Post",
      description: "Are you sure you want to delete this post?",
      optionOne: 'Delete',
      optionTwo: 'Cancel',
      pressed: () {
        BlocProvider.of<LostAndFoundAddBloc>(context)
            .add(deleteLostAndFound(pet.postID));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Deleted Successfully!'),
          backgroundColor: Colors.green,
        ));
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => lostAndFoundList(),
          ),
        );
      },
    );
  }

  confirm(context) {
    return CustomAlertDialog(
      title: "Confirm",
      description: "Confirm marking this pet as found?",
      optionOne: 'Confirm',
      optionTwo: 'Cancel',
      pressed: () {
        BlocProvider.of<LostAndFoundAddBloc>(context)
            .add(updateLostAndFound(pet.postID));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('The status has been changed successfully'),
          backgroundColor: Colors.green,
        ));
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => lostAndFoundList(),
          ),
        );
      },
    );
  }
}
