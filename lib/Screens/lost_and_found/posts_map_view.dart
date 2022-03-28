import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'dart:ui' as ui;
import 'package:petzone/Screens/lost_and_found/my_lost_and_found_details.dart';
import 'package:petzone/bloc/lost_and_found/lost_and_found_list_bloc.dart';
import 'package:petzone/model/lost_and_found.dart';
import 'lost_and_found_details.dart';

class lostAndFoundMap extends StatefulWidget {
  final List<lostAndFoundPost> posts;
  final LatLng currentLatLng;
  const lostAndFoundMap(
      {Key? key, required this.posts, required this.currentLatLng})
      : super(key: key);
  @override
  createState() => _lostAndFoundMapState();
}

class _lostAndFoundMapState extends State<lostAndFoundMap> {
  List<lostAndFoundPost>? posts;
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  LatLng? currentLatLng;
  Set<Circle>? circles;
  LostAndFoundListBloc? _lostBloc;

  @override
  initState() {
    super.initState();
    _lostBloc = BlocProvider.of<LostAndFoundListBloc>(context);
    _lostBloc!.add(LoadMyLostAndFoundList());
    posts = widget.posts;
    currentLatLng = widget.currentLatLng;
    Circle c = Circle(
        circleId: CircleId('0'),
        center: LatLng(currentLatLng!.latitude, currentLatLng!.longitude),
        radius: 5000,
        fillColor: Colors.blue.shade100.withOpacity(0.5),
        strokeColor: Colors.blue.shade100.withOpacity(0.1));
    circles = Set.from([c]);
    setMarkers();
  }

  void setMarkers() async {
    for (lostAndFoundPost p in posts!) {
      List<String> latlng =
          p.location.substring(1, p.location.length - 1).split(',');
      LatLng postLocation =
          LatLng(double.parse(latlng[0]), double.parse(latlng[1]));

      MarkerId markId = MarkerId(p.postID);
      Marker marker = Marker(
          icon: await getMarkerIcon(
              p.type, p.imgUrl[0].toString(), Size(150.0, 150.0)),
          markerId: markId,
          position: postLocation,
          infoWindow: InfoWindow(
              title: p.type,
              snippet: p.distance.toString() + ' m away',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => lostAndFoundDetails(pet: p)),
                  )));
      setState(() {
        markers[markId] = marker;
      });
    }
  }

  Future<void> setMyMarkers(List<lostAndFoundPost>? Myposts) async {
    for (lostAndFoundPost p in Myposts!) {
      List<String> latlng =
          p.location.substring(1, p.location.length - 1).split(',');
      LatLng postLocation =
          LatLng(double.parse(latlng[0]), double.parse(latlng[1]));

      double distance = GeolocatorPlatform.instance.distanceBetween(
          currentLatLng!.latitude,
          currentLatLng!.longitude,
          postLocation.latitude,
          postLocation.longitude);

      if (distance > 5000) continue;
      MarkerId markId = MarkerId(p.postID);
      Marker marker = Marker(
          icon: await getMarkerIcon(
              p.type, p.imgUrl[0].toString(), Size(150.0, 150.0)),
          markerId: markId,
          position: postLocation,
          infoWindow: InfoWindow(
              title: p.type,
              snippet: distance.ceilToDouble().toString() + ' m away',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyLostAndFoundDetails(pet: p)),
                  )));
      setState(() {
        markers[markId] = marker;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<LostAndFoundListBloc, LostAndFoundListState>(
      listener: (context, state) {
        if (state is LostAndFoundListSuccess) {
          setMyMarkers(state.docs);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Lost And Found Pets",
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
          body: Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.01),
            child: GoogleMap(
              circles: circles!,
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
          )),
    );
  }

  Future<BitmapDescriptor> getMarkerIcon(
      String tag, String imagePath, Size size) async {
    Color? color = tag == 'Lost' ? Colors.red[400] : Colors.lightGreen;
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint tagPaint = Paint()..color = color!;
    final double tagWidth = 40.0;

    final Paint shadowPaint = Paint()..color = color.withAlpha(100);
    final double shadowWidth = 15.0;

    final Paint borderPaint = Paint()..color = Colors.white;
    final double borderWidth = 3.0;

    final double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowPaint);

    // Add border circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(shadowWidth, shadowWidth,
              size.width - (shadowWidth * 2), size.height - (shadowWidth * 2)),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        borderPaint);

    // Oval for the image
    Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
        size.width - (imageOffset * 2), size.height - (imageOffset * 2));

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    // Add image
    final Response url = await get(Uri.parse(imagePath));
    final Completer<ui.Image> completer = new Completer();

    ui.decodeImageFromList(url.bodyBytes, (ui.Image img) {
      return completer.complete(img);
    });
    ui.Image image = await completer.future;
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(uint8List);
  }
}
