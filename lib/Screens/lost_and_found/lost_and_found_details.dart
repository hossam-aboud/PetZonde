import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:petzone/model/lost_and_found.dart';
import 'package:petzone/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';

class lostAndFoundDetails extends StatelessWidget {
  final lostAndFoundPost pet;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId markId = MarkerId('0');

  List<String> latlng() {
    List<String> latlng =
        pet.location.substring(1, pet.location.length - 1).split(',');

    return latlng;
  }

  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  lostAndFoundDetails({required this.pet});

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
                                  ? AssetImage('assets/pet_profile_picture.png')
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                    pet.status == 'open'
                                        ? Text('')
                                        : Icon(Icons.lock_outline),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      color: Colors.teal,
                                      size: 23,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.01,
                                    ),
                                    Text(
                                      'Posted By: ' + pet.user!.name,
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
                                          DateFormat('dd/MM/yyyy, hh:mm a')
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
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.teal,
                                      size: 23,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.01,
                                    ),
                                    Text(
                                      pet.distance.toString() + ' meters away',
                                      style: const TextStyle(
                                          color: Colors.teal,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
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
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Container(
                              margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                              //padding: const EdgeInsets.symmetric(horizontal: 16),
                              height: 70,
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
                                            icon: BitmapDescriptor
                                                .defaultMarkerWithHue(
                                                    BitmapDescriptor.hueOrange),
                                            markerId: markId,
                                            position: LatLng(
                                                double.parse(latlng()[0]),
                                                double.parse(latlng()[1])))
                                      },
                                      onMapCreated: _onMapCreated,
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
                          Container(height: 75)
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: buildFloat(),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: buildBottomBar(),
      ),
      extendBody: true,
    );
  }

  buildFloat() {
    if (pet.status == 'open')
      return FloatingActionButton.extended(
        backgroundColor: PrimaryButton,
        onPressed: () {
          _launchWhatsapp(pet.user!.phoneNum);
        },
        isExtended: true,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        icon: Icon(Icons.whatsapp),
        label: Text('Contact', style: TextStyle(fontSize: 16)),
      );
    else
      Container();
  }

  buildBottomBar() {
    if (pet.status == 'open')
      return Container(
        height: 50.0,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white30,
            Colors.white70,
            Colors.white
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
        )),
      );
    else
      Container();
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

  _launchWhatsapp(String number) async {
    String phoneNum = number.substring(1);
    String url = "https://wa.me/966$phoneNum";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
