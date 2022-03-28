import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petzone/Screens/homepage/home_page.dart';
import 'package:petzone/bloc/lost_and_found/lost_and_found_add_bloc.dart';
import 'package:petzone/widgets/custom_button.dart';
import 'package:petzone/Screens/lost_and_found/lost_and_found_location.dart';

import '../../constants.dart';
import 'lost_and_found_list.dart';

class addLostAndFound extends StatefulWidget {
  const addLostAndFound({Key? key}) : super(key: key);

  @override
  _addLostAndFoundState createState() => _addLostAndFoundState();
}

class _addLostAndFoundState extends State<addLostAndFound> {
  LatLng? currentLatLng;
  LatLng? location;
  String? address;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  callback(LatLng newLocation) async {
    setState(() {
      location = newLocation;
      MarkerId markId = MarkerId('0');
      Marker marker = Marker(
        markerId: markId,
        position: location!,
      );
      markers[markId] = marker;
      mapController.moveCamera(CameraUpdate.newLatLng(location!));
    });
    address =
        await placemarkFromCoordinates(location!.latitude, location!.longitude)
            .then((value) {
      print(value.first.toString());
      return value.first.street.toString() +
          ', ' +
          value.first.postalCode.toString() +
          ', ' +
          value.first.subLocality.toString() +
          ', ' +
          value.first.locality.toString();
    });
  }

  final ImagePicker imagePicker = ImagePicker();
  List<Image>? imageFileList = [];
  int _current = 0;
  final CarouselController _controller = CarouselController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLost = false, isFound = false;
  List<String> imagePathList = [];
  final descControl = TextEditingController();

  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void initState() {
    locatePosition();
  }

  void locatePosition() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentLatLng = LatLng(position.latitude, position.longitude);
    });
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // photo, name, description, age, city. gender, vacc, set,
    return BlocListener<LostAndFoundAddBloc, LostAndFoundAddState>(
      listener: (context, state) {
        if (state is LostAndFoundAddFail) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Text('Submit Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Color(0xffffae88),
              ),
            );
        }

        if (state is LostAndFoundAddLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Text('Submitting...'),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                ],
              ),
              backgroundColor: Color(0xffffae88),
            ),
          );
        }
        if (state is LostAndFoundAddSuccess) {
          ScaffoldMessenger.of(context).clearSnackBars();
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => lostAndFoundList()),
          );
        }
      },
      child: BlocBuilder<LostAndFoundAddBloc, LostAndFoundAddState>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                brightness: Brightness.light,
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  "Add Lost And Found Post",
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
              backgroundColor: Colors.white,
              key: _scaffoldKey,
              body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 300.0,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                            ),
                            Positioned(
                              top: 30.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: imageFileList!.length != 0
                                            ? Container(
                                                height: 210,
                                                //  color: Color(0xFFf0f4f4),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CarouselSlider(
                                                        items: imageFileList!
                                                            .map((img) {
                                                          return Builder(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Stack(
                                                                children: [
                                                                  Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              5.0),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white),
                                                                      child:
                                                                          Image(
                                                                        image: img
                                                                            .image,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )),
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      selectImages();
                                                                    },
                                                                    child: Text(
                                                                        '+'),
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      primary: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.4),
                                                                      shape:
                                                                          CircleBorder(),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              0.5),
                                                                    ),
                                                                  )
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        }).toList(),
                                                        carouselController:
                                                            _controller,
                                                        options:
                                                            CarouselOptions(
                                                                enableInfiniteScroll:
                                                                    false,
                                                                height: 180,
                                                                enlargeCenterPage:
                                                                    true,
                                                                aspectRatio:
                                                                    1.0,
                                                                onPageChanged:
                                                                    (index,
                                                                        reason) {
                                                                  setState(() {
                                                                    _current =
                                                                        index;
                                                                  });
                                                                }),
                                                      ),
                                                    ]),
                                              )
                                            : Container(
                                                decoration:
                                                    BoxDecoration(boxShadow: [
                                                  //background color of box
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    blurRadius:
                                                        25.0, // soften the shadow
                                                    spreadRadius:
                                                        5.0, //extend the shadow
                                                    offset: Offset(
                                                      1.0, // Move to right 10  horizontally
                                                      5.0, // Move to bottom 10 Vertically
                                                    ),
                                                  )
                                                ], color: Colors.white),
                                                height: 210,
                                                //  color: Color(0xFFf0f4f4),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      selectImages();
                                                    },
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              'Upload Pet\'s Picture',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color:
                                                                      SubTextColor)),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          CircleAvatar(
                                                            radius: 40,
                                                            backgroundColor:
                                                                Color(
                                                                    0xffD0F1EB),
                                                            foregroundImage:
                                                                Image.asset(
                                                                        'assets/pickimage.png')
                                                                    .image,
                                                          )
                                                        ])),
                                              ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      descField("Pet's Description"),
                      SizedBox(height: 10),
                      ListTile(
                        title: Text(
                          'Type',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: TextColor),
                        ),
                        subtitle: Container(
                          width: double.infinity,
                          height: 60,
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: double.infinity,
                                  child: Card(
                                    semanticContainer: true,
                                    color: isLost
                                        ? AcceptButton
                                        : Color(0xFFE5E5E5),
                                    child: InkWell(
                                        onTap: () async {
                                          setState(() {
                                            isLost = true;
                                            isFound = false;
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              isLost
                                                  ? Icon(
                                                      Icon(
                                                        Icons.check_circle,
                                                      ).icon,
                                                      color: Colors.white,
                                                    )
                                                  : Container(),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text('Lost Pet',
                                                  style: TextStyle(
                                                      color: isLost
                                                          ? Colors.white
                                                          : TextColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16)),
                                              SizedBox(
                                                width: 5,
                                              )
                                            ],
                                          ),
                                        )),
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                  height: double.infinity,
                                  child: Card(
                                    semanticContainer: true,
                                    color: isFound
                                        ? AcceptButton
                                        : Color(0xFFE5E5E5),
                                    child: InkWell(
                                        onTap: () async {
                                          setState(() {
                                            isLost = false;
                                            isFound = true;
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              isFound
                                                  ? Icon(
                                                      Icon(
                                                        Icons.check_circle,
                                                      ).icon,
                                                      color: Colors.white,
                                                    )
                                                  : Container(),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text('Found Pet',
                                                  style: TextStyle(
                                                      color: isFound
                                                          ? Colors.white
                                                          : TextColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16)),
                                              SizedBox(
                                                width: 5,
                                              )
                                            ],
                                          ),
                                        )),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      ListTile(
                        title: Text(
                          'Location',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: TextColor),
                        ),
                      ),
                      Container(
                        height: size.height * 0.25,
                        width: size.width * 0.95,
                        child: currentLatLng == null
                            ? Center(child: CircularProgressIndicator())
                            : GoogleMap(
                                onTap: (LatLng) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => locationView(
                                            currentLatLng!, callback))),
                                markers: Set<Marker>.of(markers.values),
                                onMapCreated: _onMapCreated,
                                mapType: MapType.normal,
                                myLocationEnabled: true,
                                initialCameraPosition: CameraPosition(
                                    target: currentLatLng!, zoom: 12.0),
                              ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomButton(
                              text: 'Add +',
                              textSize: 20,
                              textColor: Colors.white,
                              color: PrimaryButton,
                              size: Size(size.width * 0.4, 55),
                              pressed: () {
                                if (_formKey.currentState!.validate() &&
                                    validate()) {
                                  BlocProvider.of<LostAndFoundAddBloc>(
                                          this.context)
                                      .add(submitLostAndFound(
                                          descControl.text,
                                          isFound ? 'Found' : 'Lost',
                                          address!,
                                          imagePathList,
                                          location!.toJson().toString()));
                                } else
                                  Scaffold.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const <Widget>[
                                            Text('Invalid Fields'),
                                            Icon(Icons.error),
                                          ],
                                        ),
                                        backgroundColor: Color(0xffffae88),
                                      ),
                                    );
                              }),
                          CustomButton(
                              text: 'Cancel',
                              textSize: 20,
                              textColor: PrimaryButton,
                              borderColor: PrimaryButton,
                              color: PrimaryLightButton,
                              size: Size(size.width * 0.3, 55),
                              pressed: () {
                                Navigator.pop(context);
                              })
                        ],
                      )
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }

  Widget descField(String _label) {
    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.only(left: 20, right: 15),
      child: TextFormField(
        controller: descControl,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter description';
          }
          if (value.length < 10) {
            return 'Pet description must be 10 characters or longer';
          }
          if (value.length > 250) {
            return 'Pet description must not exceed 250 characters';
          }
          if (!RegExp(r'^[A-Za-z0-9,. ]+$').hasMatch(value))
            return 'Pet description must not have special characters.';
          return null;
        },
        textAlign: TextAlign.start,
        minLines: 4,
        maxLines: 10,
        decoration: InputDecoration(
          labelText: 'Pet\'s Description',
          filled: true,
          fillColor: Color(0xFFE5E5E5),
          floatingLabelStyle:
              TextStyle(fontWeight: FontWeight.bold, color: TextColor),
          focusedBorder: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: BorderSide(color: Color(0xFFE5E5E5), width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Color(0xFFE5E5E5), width: 2.0),
          ),
        ),
        style: TextStyle(fontSize: 18, color: SubTextColor),
      ),
    );
  }

  void selectImages() async {
    final XFile? pickImg =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickImg! != null) {
      setState(() {
        Image img = Image.file(File(pickImg.path));
        if (imagePathList.length > 0) {
          imagePathList.removeAt(0);
          imageFileList!.removeAt(0);
        }

        imagePathList.add(pickImg.path);
        imageFileList!.add(img);
        print('len:' + imagePathList.length.toString());
      });
    }
    print("Image List Length:" + imageFileList!.length.toString());
  }

  bool validate() {
    if (location == null) return false;

    if (imagePathList.isEmpty) return false;

    if (!isFound && !isLost) return false;

    return true;
  }
}
