import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import '../constants.dart';
import '../model/MedicalData.dart';
import '../service/authentication_service.dart';
import 'ProfilePet.dart';
import 'add_pet.dart';

class PetsListPage extends StatefulWidget {
  PetsListPage({Key? key}) : super(key: key);

  @override
  PetsListPageState createState() => PetsListPageState();
}

class PetsListPageState extends State<PetsListPage> {
  @override
  Widget build(BuildContext context) {
    /* return Container(
      child: FutureBuilder(
          future: _fetchListItems(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return  Center(child: CircularProgressIndicator());
            } else {
              Container(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Text('${snapshot.data[index].name}');
                      }));
            }
          }),
    );

    */

    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "My Pets",
            style: TextStyle(
              color: Colors.teal[800],
            ),
          ),
        ),
        body: Center(
            child: Container(
                child: Column(children: [
          new FutureBuilder(
              future: _fetchListItems(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (AllPets.isEmpty)
                  return Center(
                    child: Text(
                      'No Added Pets',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  );
                return Column(children: <Widget>[
                  Container(
                    child: new ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var beer = AllPets[index];
                        return GestureDetector(
                          onTap: () {
                            /* not ready yet to be presented
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePet(
                                    pet: beer,
                                  ),
                                ));
                                */
                          },
                          child: new Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: CircleAvatar(
                                                radius: 50,
                                                foregroundImage: (beer.imgUrl !=
                                                        null)
                                                    ? NetworkImage(beer.imgUrl!)
                                                    : Image.asset(
                                                            "assets/pet_profile_picture.png")
                                                        .image)),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(beer.name,
                                                    style: TextStyle(
                                                      color: TextColor,
                                                      fontSize: 19.0,
                                                    )),
                                              ],
                                            ),
                                            Container(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                    "Breed: " + beer.breed)),
                                            Container(
                                                alignment: Alignment.topLeft,
                                                child:
                                                    Text(getStringData(beer))),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Icon(Icons.arrow_forward_ios_outlined,
                                        color: Colors.grey),
                                  ],
                                ),
                              )),
                        );
                      },
                      itemCount: AllPets == null ? 0 : AllPets.length,
                    ),
                  )
                ]);
              })
        ]))),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => addPetScreen()),
            );
          },
          child: const Icon(Icons.add),
          backgroundColor: PrimaryButton,
        ));
  }

  List<MedicalData> AllPets = [];
  _fetchListItems() async {
    AuthenticationService authenticationService = AuthenticationService();
    AllPets = await authenticationService.getAllPets();
    return AllPets;
  }

  String getStringData(MedicalData data) {
    String result = "";
    if (data.cat_or_dog == "cat") {
      result = "Cat | ";
    } else {
      result = "Dog | ";
    }
    if (data.stersllized == "true") {
      result += "Stersllized";
    } else {
      result += "Not Stersllized";
    }
    return result;
  }
}
