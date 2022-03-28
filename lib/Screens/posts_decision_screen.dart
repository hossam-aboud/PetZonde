import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/Screens/adoption/decision_result.dart';
import 'package:petzone/Screens/adoption/request_confirm.dart';
import 'package:petzone/bloc/adoption_decision/adopt_decision_bloc.dart';
import 'package:petzone/model/adoption_request.dart';

import '../model/PetLover.dart';
import '../model/adoption_post.dart';
import '../service/notification_service.dart';

class PostsDecisionScreen extends StatefulWidget {
  final adoptionRequest request;
  final adoptionPost post;


  const PostsDecisionScreen({Key? key, required this.request, required this.post}) : super(key: key);

  @override
  State<PostsDecisionScreen> createState() => _PostsDecisionScreenState();
}

class _PostsDecisionScreenState extends State<PostsDecisionScreen> {
  final FCMNotificationService _fcmNotificationService =
      FCMNotificationService();

  late adoptionRequest request;
  late adoptionPost post;
  bool anotherPet = true;
  bool hasKids = true;
  int isFriendly = -1;
  double sysWidth = 0.0;
  double sysHeight = 0.0;
  int typeValue = 1;
  late PetLover petlover;
  late String home;

  @override
  initState() {
    super.initState();
    request = widget.request;
    post = widget.post;
    setKids(request.hasKids);
    setFriendly(request.isFriendly);
    setPet(request.anotherPet);
    setHome(request.type);
    petlover = request.perLover;
  }

  setHome(int value) {
    switch (value) {
      case 1:
        home = 'Apartment';
        break;
      case 2:
        home = 'Villa';
    }
  }

  setKids(bool value) {
    setState(() {
      hasKids = value;
    });
  }

  setFriendly(int value) {
    setState(() {
      isFriendly = value;
    });
  }

  setPet(bool value) {
    setState(() {
      anotherPet = value;
    });
  }

  Widget wdQuestion(String title) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
      child: Text(
        title,
        style: const TextStyle(color: Colors.black54, fontSize: 16),
      ),
    );
  }

  Widget wdRadio() {
    return Row(
      children: [
        InkWell(
          child: SizedBox(
            width: sysWidth / 2 - 30,
            child: Row(
              children: [
                Icon(
                  anotherPet
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  size: 15,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                )
              ],
            ),
          ),
        ),
        InkWell(
          child: SizedBox(
            width: 120,
            child: Row(
              children: [
                Icon(
                  anotherPet
                      ? Icons.radio_button_off
                      : Icons.radio_button_checked,
                  size: 15,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "No",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget wdMiddleRadio() {
    return Column(
      children: [
        Row(
          children: [
            InkWell(
              child: SizedBox(
                width: sysWidth / 2 - 30,
                child: Row(
                  children: [
                    Icon(
                      isFriendly == 0
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      size: 15,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "Yes",
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              child: SizedBox(
                width: 120,
                child: Row(
                  children: [
                    Icon(
                      isFriendly == 1
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      size: 15,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "No",
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget wdKidRadio() {
    return Row(
      children: [
        InkWell(
          child: SizedBox(
            width: sysWidth / 2 - 30,
            child: Row(
              children: [
                Icon(
                  hasKids ? Icons.radio_button_checked : Icons.radio_button_off,
                  size: 15,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                )
              ],
            ),
          ),
        ),
        InkWell(
          child: SizedBox(
            width: 120,
            child: Row(
              children: [
                Icon(
                  hasKids ? Icons.radio_button_off : Icons.radio_button_checked,
                  size: 15,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "No",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    sysWidth = size.width;
    sysHeight = size.height;
    return  SingleChildScrollView(
          child: BlocConsumer<AdoptDecisionBloc, AdoptDecisionState>(
            listener: (BuildContext context, state) {
              if (state is Saved) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const DecisionResult(wasAccept: true)));
              }
              if (state is AdoptDecisionError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (BuildContext context, Object? state) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                child: Column(
                  children: [
                    wdQuestion("Do you have another pet ?"),
                    Container(
                      padding: const EdgeInsets.fromLTRB(13, 6, 6, 6),
                      child: wdRadio(),
                    ),
                    Visibility(
                        visible: isFriendly != 2,
                        child: Column(
                          children: [
                            wdQuestion(
                                "If you have another pet are they friendly ?"),
                            Container(
                              padding: const EdgeInsets.fromLTRB(13, 6, 6, 6),
                              child: wdMiddleRadio(),
                            ),
                          ],
                        )),
                    wdQuestion("Do you have Kids ?"),
                    Container(
                        padding: const EdgeInsets.fromLTRB(13, 6, 6, 6),
                        child: wdKidRadio()),
                    wdQuestion("Accommodation type:"),
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        home,
                        style:
                            TextStyle(color: Color(0xFF63D2CC), fontSize: 15),
                      ),
                    ),
                    const SizedBox(height: 10),
                    wdQuestion("Why do want to adopt ?"),
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        request.reason.toString(),
                        softWrap: true,
                        style:
                            TextStyle(color: Color(0xFF63D2CC), fontSize: 15),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 10),

                    //if post is open for adoption
                    if(!post.adopted)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            BlocProvider.of<AdoptDecisionBloc>(context).add(
                              AdoptDecisionFunction("Rejected", request.postID,
                                  request.requestID),
                            );
                            //send notification to pet lover
                            List<dynamic> tokens = await _fcmNotificationService
                                .getUserToken(petlover.uid);
                            try {
                              tokens.forEach((element) {
                                print("array: " + element.toString());
                                _fcmNotificationService.sendNotificationToUser(
                                  fcmToken: element.toString(),
                                  title: "Adoption request",
                                  body:
                                      "your adoption request has been rejected",
                                );
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Notification sent.'),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error, ${e.toString()}.'),
                                ),
                              );
                            }
                          },
                          style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(140, 40)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFFF88A8A)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      side: BorderSide(
                                          color: Color(0xFFF88A8A))))),
                          child: const Text("Reject",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            BlocProvider.of<AdoptDecisionBloc>(context).add(
                              AdoptDecisionFunction("Approved", request.postID,
                                  request.requestID),
                            );
                            //send notification to pet lover
                            List<dynamic> tokens = await _fcmNotificationService
                                .getUserToken(petlover.uid);
                            try {
                              tokens.forEach((element) {
                                print("array: " + element.toString());
                                _fcmNotificationService.sendNotificationToUser(
                                  fcmToken: element.toString(),
                                  title: "Adoption request",
                                  body:
                                      "your adoption request has been accepted",
                                );
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Notification sent.'),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error, ${e.toString()}.'),
                                ),
                              );
                            }
                          },
                          style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(140, 40)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF63D2CC)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      side: BorderSide(
                                          color: Color(0xFF63D2CC))))),
                          child: const Text("Approve",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                      ],
                    ),

                    //if status is pending and the post is already adopted then the request is rejected
                    if(request.status=="Pending" && post.adopted == true)
                      Row(
                        children: [
                          Text("Status: ",
                              style: TextStyle(fontSize: 20, color: Colors.black54)),
                          Text("Rejected",
                              style: TextStyle(
                                  color: Colors.red, fontSize: 20)),
                        ],
                      ),

                    //if status is adopted and post status is adopted then show therequest status
                    if(request.status=="Approved" && post.adopted == true)
                      Row(
                        children: [
                          Text("Status: ",
                              style: TextStyle(fontSize: 18, color: Colors.black54)),
                          Text("Approved",
                              style: TextStyle(
                                  color: Colors.green, fontSize: 18, )),
                        ],
                      ),

                    //if status is rejected and post status is adopted then show the request status
                    if(request.status=="Rejected" && post.adopted == true)
                      Row(
                        children: [
                          Text("Status: ",
                              style: TextStyle(fontSize: 18, color: Colors.black54)),
                          Text("Rejected",
                              style: TextStyle(
                                  color: Colors.red, fontSize: 18)),
                        ],
                      ),
                  ],
                ),
              );
              return Container();
            },
          ),
        );
  }
}
