import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petzone/bloc/adoption_post/adoption_post_bloc.dart';
import 'package:petzone/widgets/custom_button.dart';

import '../../constants.dart';
import 'org_adpoption_post_list.dart';

class CreateAdoptionScreen extends StatefulWidget {
  const CreateAdoptionScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreateAdoptionScreen> {
  final ImagePicker imagePicker = ImagePicker();
  List<Image>? imageFileList = [];
  bool imgNumValidator = true;
  bool imgEmptyValidator = true;
  int _current = 0;
  final CarouselController _controller = CarouselController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? dropdownvalue;
  var items = [
    'Riyadh',
    'Makkah',
    'Dammam',
    'Abha',
    'Jazan',
    'Madinah',
    'Buraidah',
    'Tabuk',
    'Ha\'il',
    'Najran',
    'Sakaka',
    'Al-Baha',
    'Arar'
  ];
  String age = '';
  bool fChoice = false,
      mChoice = false,
      isVacc = false,
      isSet = false,
      notVacc = false,
      notSet = false;
  List<String> imagePathList = [];
  final nameControl = TextEditingController();
  final breedControl = TextEditingController();
  final descControl = TextEditingController();

  void initState() {
    Image _add = Image.asset('assets/add.jpg');
    imageFileList!.add(_add);
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // photo, name, description, age, city. gender, vacc, set,

    return BlocListener<AdoptionPostBloc, AdoptionPostState>(
      listener: (context, state) {
        if (state is SubmitAdoptionPostFail) {
          ScaffoldMessenger.of(context).showSnackBar(
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

        if (state is SubmitAdoptionPostLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(minutes: 5),
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
        if (state is SubmitAdoptionPostSuccess) {
          ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Text('Submit Success'),
                    Icon(Icons.check_circle),
                  ],
                ),
                backgroundColor: Colors.green,
              ),
            );
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => orgAdoptionList()),
          );
        }
      },
      child: BlocBuilder<AdoptionPostBloc, AdoptionPostState>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                brightness: Brightness.light,
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  "Add Adoption Post",
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
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: imageFileList!.length != 1
                                                ? Container(
                                                    height: 210,
                                                    //  color: Color(0xFFf0f4f4),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          CarouselSlider(
                                                            items:
                                                                imageFileList!
                                                                    .map((img) {
                                                              return Builder(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  int i = imageFileList!
                                                                      .indexOf(
                                                                          img);
                                                                  return i == 0
                                                                      ? GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            selectImages();
                                                                          },
                                                                          child: Container(
                                                                              width: MediaQuery.of(context).size.width,
                                                                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                                                                              decoration: BoxDecoration(color: Colors.white),
                                                                              child: Image(
                                                                                image: img.image,
                                                                                fit: BoxFit.cover,
                                                                              )))
                                                                      : Stack(
                                                                          children: [
                                                                            Container(
                                                                                width: MediaQuery.of(context).size.width,
                                                                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                                                                decoration: BoxDecoration(color: Colors.white),
                                                                                child: Image(
                                                                                  image: img.image,
                                                                                  fit: BoxFit.cover,
                                                                                )),
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  imageFileList!.removeAt(i);
                                                                                  imagePathList.removeAt(i - 1);
                                                                                  if (imageFileList!.length <= 6) {
                                                                                    imgNumValidator = true;
                                                                                  }
                                                                                });
                                                                              },
                                                                              child: Text('✖'),
                                                                              style: ElevatedButton.styleFrom(
                                                                                primary: Colors.black.withOpacity(0.4),
                                                                                shape: CircleBorder(),
                                                                                padding: EdgeInsets.all(0.5),
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
                                                                    height: 180,
                                                                    enlargeCenterPage:
                                                                        true,
                                                                    aspectRatio:
                                                                        1.0,
                                                                    onPageChanged:
                                                                        (index,
                                                                            reason) {
                                                                      setState(
                                                                          () {
                                                                        _current =
                                                                            index;
                                                                      });
                                                                    }),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children:
                                                                imageFileList!
                                                                    .asMap()
                                                                    .entries
                                                                    .map(
                                                                        (entry) {
                                                              return GestureDetector(
                                                                onTap: () => _controller
                                                                    .animateToPage(
                                                                        entry
                                                                            .key),
                                                                child:
                                                                    Container(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  margin: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          8.0,
                                                                      horizontal:
                                                                          4.0),
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: (Theme.of(context).brightness == Brightness.dark
                                                                              ? Colors
                                                                                  .white
                                                                              : DeclineButton)
                                                                          .withOpacity(_current == entry.key
                                                                              ? 1
                                                                              : 0.4)),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ]),
                                                  )
                                                : Container(
                                                    decoration: BoxDecoration(
                                                        boxShadow: [
                                                          //background color of box
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            blurRadius:
                                                                25.0, // soften the shadow
                                                            spreadRadius:
                                                                5.0, //extend the shadow
                                                            offset: Offset(
                                                              1.0,
                                                              // Move to right 10  horizontally
                                                              5.0, // Move to bottom 10 Vertically
                                                            ),
                                                          )
                                                        ],
                                                        color: Colors.white),
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
                                                                      fontSize:
                                                                          18,
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
                                      if (!imgNumValidator)
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Maximum number of pictures is 5",
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.red[700]),
                                          ),
                                        ),
                                      if (!imgEmptyValidator)
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Please upload pictures",
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.red[700]),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // image
                      // name
                      nameField(),
                      SizedBox(height: 20),
                      breedField(),

                      SizedBox(height: 20),
                      // desc
                      descField("Pet's Description"),
                      SizedBox(height: 20),
                      CityDropDown(),

                      SizedBox(height: 20),
                      ListTile(
                        title: Container(
                            child: Text('Pet\'s Age',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: TextColor))),
                        subtitle: Container(
                            width: double.infinity,
                            height: 50,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(25.0),
                              color: FieldColor,
                            ),
                            child: Text(
                              age.isEmpty ? 'Pet\'s Age' : age,
                              style:
                                  TextStyle(fontSize: 18, color: SubTextColor),
                            )),
                        onTap: () {
                          showPicker(context);
                        },
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        title: Text(
                          'Gender',
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
                                    color: fChoice
                                        ? Color(0xFFFF71AF)
                                        : Color(0xFFE5E5E5),
                                    child: InkWell(
                                      onTap: () async {
                                        setState(() {
                                          fChoice = true;
                                          mChoice = false;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Image(
                                              image: fChoice
                                                  ? Image.asset(
                                                          'assets/female-white.png')
                                                      .image
                                                  : Image.asset(
                                                          'assets/female.png')
                                                      .image),
                                          Text('Female',
                                              style: TextStyle(
                                                  color: fChoice
                                                      ? Colors.white
                                                      : TextColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          SizedBox(
                                            width: 5,
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                height: double.infinity,
                                child: Card(
                                  color:
                                      mChoice ? Colors.blue : Color(0xFFE5E5E5),
                                  child: InkWell(
                                      onTap: () async {
                                        setState(() {
                                          mChoice = true;
                                          fChoice = false;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Image(
                                              image: mChoice
                                                  ? Image.asset(
                                                          'assets/male-white.png')
                                                      .image
                                                  : Image.asset(
                                                          'assets/male.png')
                                                      .image),
                                          Text('Male',
                                              style: TextStyle(
                                                  color: mChoice
                                                      ? Colors.white
                                                      : TextColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          SizedBox(
                                            width: 5,
                                          )
                                        ],
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        title: Text(
                          'Is Vaccinated?',
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
                                    color: isVacc
                                        ? AcceptButton
                                        : Color(0xFFE5E5E5),
                                    child: InkWell(
                                        onTap: () async {
                                          setState(() {
                                            isVacc = true;
                                            notVacc = false;
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              isVacc
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
                                              Text('Yes',
                                                  style: TextStyle(
                                                      color: isVacc
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
                                    color: notVacc
                                        ? AcceptButton
                                        : Color(0xFFE5E5E5),
                                    child: InkWell(
                                        onTap: () async {
                                          setState(() {
                                            isVacc = false;
                                            notVacc = true;
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              notVacc
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
                                              Text('No',
                                                  style: TextStyle(
                                                      color: notVacc
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
                      SizedBox(height: 10),
                      ListTile(
                        title: Text(
                          'Is Spayed/Neutered?',
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
                                  // width: MediaQuery.of(context).size.width *0.23,
                                  child: Card(
                                    semanticContainer: true,
                                    color: isSet
                                        ? AcceptButton
                                        : Color(0xFFE5E5E5),
                                    child: InkWell(
                                        onTap: () async {
                                          setState(() {
                                            isSet = true;
                                            notSet = false;
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              isSet
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
                                              Text('Yes',
                                                  style: TextStyle(
                                                      color: isSet
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
                                    color: notSet
                                        ? AcceptButton
                                        : Color(0xFFE5E5E5),
                                    child: InkWell(
                                        onTap: () async {
                                          setState(() {
                                            isSet = false;
                                            notSet = true;
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              notSet
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
                                              Text('No',
                                                  style: TextStyle(
                                                      color: notSet
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
                      SizedBox(height: 20),

                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomButton(
                              text: 'Confirm',
                              textSize: 20,
                              textColor: Colors.white,
                              color: PrimaryButton,
                              size: Size(size.width * 0.4, 55),
                              pressed: () {
                                if (imagePathList.isEmpty) {
                                  setState(() {
                                    imgEmptyValidator = false;
                                  });
                                } else {
                                  setState(() {
                                    imgEmptyValidator = true;
                                  });
                                }
                                ;
                                if (imageFileList!.length > 6) {
                                  setState(() {
                                    imgNumValidator = false;
                                  });
                                } else {
                                  setState(() {
                                    imgNumValidator = true;
                                  });
                                }
                                ;
                                if (_formKey.currentState!.validate() &&
                                    validate()) {
                                  BlocProvider.of<AdoptionPostBloc>(
                                          context)
                                      .add(submitPost(
                                          nameControl.text,
                                          breedControl.text,
                                          descControl.text,
                                          age,
                                          fChoice ? 'Female' : 'Male',
                                          isVacc ? 'True' : 'False',
                                          isSet ? 'True' : 'False',
                                          imagePathList,
                                          dropdownvalue!));
                                } else
                                  ScaffoldMessenger.of(context).showSnackBar(
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

  showPicker(BuildContext context) {
    Picker picker = Picker(
        title: Text('Pet\'s Age'),
        adapter: PickerDataAdapter<String>(pickerdata: yList, isArray: true),
        changeToFirst: false,
        textAlign: TextAlign.left,
        textStyle: TextStyle(color: Colors.grey, fontSize: 18),
        selectedTextStyle: TextStyle(color: SubTextColor, fontSize: 18),
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          setState(() {
            age = picker
                .getSelectedValues()
                .toString()
                .replaceAll('[', '')
                .replaceAll(']', '');
          });
        });
    picker.show(_scaffoldKey.currentState!);
  }

  Widget CityDropDown() {
    return Container(
        width: double.infinity,
        // height: 50,
        padding: const EdgeInsets.only(left: 20, right: 15),
        child: DropdownButtonFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.location_on,
                color: Colors.black12,
                size: 23,
              ),
              labelText: "City",
              floatingLabelStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: TextColor),
              filled: true,
              fillColor: Color(0xFFE5E5E5),
              focusedBorder: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
              ),
            ),
            // Initial Value
            value: dropdownvalue,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down),
            style: new TextStyle(
              color: SubTextColor,
              fontSize: 18,
            ),

            // Array list of items
            items: items.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownvalue = newValue!;
              });
            }));
  }

  Widget nameField() {
    return Container(
      width: double.infinity,
      height: 70,
      padding: const EdgeInsets.only(left: 20, right: 15),
      child: TextFormField(
        controller: nameControl,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter name';
          }
          if (value.length < 3) {
            return 'Pet name must be 3 characters or longer';
          }

          if (value.length > 25) {
            return 'Pet name must not exceed 25 characters';
          }

          if (!RegExp(r'^[A-Za-z0-9. ]+$').hasMatch(value))
            return 'Pet name must not have special characters.';

          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.pets_outlined,
            color: Colors.black12,
            size: 23,
          ),
          labelText: "Pet's Name",
          floatingLabelStyle: TextStyle(
              height: 0, fontWeight: FontWeight.bold, color: TextColor),
          filled: true,
          fillColor: Color(0xFFE5E5E5),
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

  Widget breedField() {
    return Container(
      width: double.infinity,
      height: 70,
      padding: const EdgeInsets.only(left: 20, right: 15),
      child: TextFormField(
        controller: breedControl,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter breed';
          }
          if (value.length < 3) {
            return 'Pet Breed must be 3 characters or longer';
          }

          if (value.length > 15) {
            return 'Pet Breed must not exceed 15 characters';
          }

          if (!RegExp(r'^[A-Za-z0-9. ]+$').hasMatch(value))
            return 'Pet Breed must not have special characters.';

          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.pets_outlined,
            color: Colors.black12,
            size: 23,
          ),
          labelText: "Pet's Breed",
          floatingLabelStyle: TextStyle(
              height: 0, fontWeight: FontWeight.bold, color: TextColor),
          filled: true,
          fillColor: Color(0xFFE5E5E5),
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
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages!.isNotEmpty) {
      //imageFileList!.addAll(selectedImages);
      setState(() {
        for (XFile i in selectedImages) {
          Image img = Image.file(File(i.path));
          imagePathList.add(i.path);
          imageFileList!.add(img);
        }
        imgNumValidator = true;
        imgEmptyValidator = true;
      });
    }

    print("Image List Length:" + imageFileList!.length.toString());
  }

  bool validate() {
    if (imagePathList.isEmpty) return false;

    if (imagePathList.length > 5) return false;

    if (!isVacc && !notVacc) return false;

    if (!isSet && !notSet) return false;

    if (!fChoice && !mChoice) return false;

    return true;
  }
}

const yList = [
  [
    '0 Years',
    '1 Year',
    '2 Years',
    '3 Years',
    '4 Years',
    '5 Years',
    '6 Years',
    '7 Years',
    '8 Years',
    '9 Years',
    '10 Years',
    '11 Years',
    '12 Years',
    '13 Years',
    '14 Years',
    '15 Years',
    '16 Years',
    '17 Years',
    '18 Years',
    '19 Years',
    '20 Years',
    '21 Years',
    '22 Years',
    '23 Years',
    '24 Years',
    '25 Years',
    '26 Years',
    '27 Years',
    '28 Years',
    '29 Years',
    '30 Years'
  ],
  [
    '1 month',
    '2 months',
    '3 months',
    '4 months',
    '5 months',
    '6 months',
    '7 months',
    '8 months',
    '9 months',
    '10 months',
    '11 months'
  ]
];
