import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants.dart';
import '../../widgets/custom_button.dart';

class locationView extends StatefulWidget {
  LatLng currentLatLng;
  Function(LatLng) callback;
  locationView(this.currentLatLng, this.callback);

  @override
  _locationState createState() => _locationState();
}

class _locationState extends State<locationView> {
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  LatLng? currentLatLng;
  LatLng? location;

  @override
  void initState() {
    super.initState();
    currentLatLng = widget.currentLatLng;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Add Lost And Found Pet Location",
          style: TextStyle(
            color: Colors.teal[800],
          ),
        ),
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
      body: Column(
        children: [
          currentLatLng == null
              ? Center(child: CircularProgressIndicator())
              : Container(
                  height: size.height * 0.825,
                  child: GoogleMap(
                    onTap: (LatLng) {
                      MarkerId markId = MarkerId('0');
                      Marker marker =
                          Marker(markerId: markId, position: LatLng);
                      setState(() {
                        location = LatLng;
                        markers[markId] = marker;
                      });
                    },
                    markers: Set<Marker>.of(markers.values),
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    initialCameraPosition:
                        CameraPosition(target: currentLatLng!, zoom: 12.0),
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                  ),
                ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: PrimaryButton,
        onPressed: () {
          if (location != null) {
            widget.callback(location!);
            Navigator.pop(context);
          } else
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.orange,
                content: Text('Please Select A location')));
        },
        isExtended: true,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: Text('Confirm', style: TextStyle(fontSize: 20)),
      ),
    ));
  }
}
