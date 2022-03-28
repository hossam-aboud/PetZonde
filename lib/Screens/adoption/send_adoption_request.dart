import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/Screens/adoption/request_confirm.dart';
import 'package:petzone/bloc/adoption_request.dart/adopt_req_bloc.dart';

import '../../constants.dart';
import '../../model/adoption_post.dart';
import '../../service/notification_service.dart';
import '../../widgets/custom_button.dart';

class sendAdoptionRequest extends StatefulWidget {
  final String postID;
  final adoptionPost pet;

  const sendAdoptionRequest({Key? key, required this.postID, required this.pet})
      : super(key: key);

  @override
  _sendAdoptionRequestState createState() => _sendAdoptionRequestState();
}

class _sendAdoptionRequestState extends State<sendAdoptionRequest> {
  final FCMNotificationService _fcmNotificationService =
      FCMNotificationService();

  // bool anotherPet = true;
  final _formKey = GlobalKey<FormState>();
  String kidsError = '';
  String anotherPetError = '';
  String isFriendlyError = '';
  bool? anotherPet;
  bool? hasKids;

  // bool hasKids = true;
  int isFriendly = -1;
  double sysWidth = 0.0;
  double sysHeight = 0.0;

  // int typeValue = 1;
  int? typeValue;
  String? postID;
  adoptionPost? pet;

  @override
  void initState() {
    postID = widget.postID;
    pet = widget.pet;
  }

  final TextEditingController _ctrlNote = TextEditingController();

  setKids(bool value) {
    setState(() {
      hasKids = value;
      kidsError = '';
    });
  }

  setFriendly(int value) {
    setState(() {
      isFriendly = value;
      isFriendlyError = '';
    });
  }

  setPet(bool value) {
    setState(() {
      anotherPet = value;
      anotherPetError = '';
    });
  }

  Widget wdQuestion(String title) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
      child: Text(
        title,
        style: const TextStyle(color: TextColor, fontSize: 16),
      ),
    );
  }

  Widget wdRadio() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            setPet(true);
          },
          child: SizedBox(
            width: sysWidth / 2 - 30,
            child: Row(
              children: [
                Icon(
                  anotherPet == null
                      ? Icons.radio_button_off
                      : anotherPet!
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                  size: 15,
                  color: Colors.teal[600],
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
          onTap: () {
            setPet(false);
          },
          child: SizedBox(
            width: 120,
            child: Row(
              children: [
                Icon(
                  anotherPet == null
                      ? Icons.radio_button_off
                      : anotherPet!
                          ? Icons.radio_button_off
                          : Icons.radio_button_checked,
                  size: 15,
                  color: Colors.teal[600],
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
              onTap: () {
                setFriendly(0);
              },
              child: SizedBox(
                width: sysWidth / 2 - 30,
                child: Row(
                  children: [
                    Icon(
                      isFriendly == 0
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      size: 15,
                      color: Colors.teal[600],
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
              onTap: () {
                setFriendly(1);
              },
              child: SizedBox(
                width: 120,
                child: Row(
                  children: [
                    Icon(
                      isFriendly == 1
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      size: 15,
                      color: Colors.teal[600],
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
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget wdKidRadio() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            setKids(true);
          },
          child: SizedBox(
            width: sysWidth / 2 - 30,
            child: Row(
              children: [
                Icon(
                  hasKids == null
                      ? Icons.radio_button_off
                      : hasKids!
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                  size: 15,
                  color: Colors.teal[600],
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
          onTap: () {
            setKids(false);
          },
          child: SizedBox(
            width: 120,
            child: Row(
              children: [
                Icon(
                  hasKids == null
                      ? Icons.radio_button_off
                      : hasKids!
                          ? Icons.radio_button_off
                          : Icons.radio_button_checked,
                  size: 15,
                  color: Colors.teal[600],
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Adoption Request",
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
        body: SingleChildScrollView(
          child: BlocConsumer<AdoptRequestBloc, AdoptRequestState>(
            listener: (BuildContext context, state) {
              if (state is Saved) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RequestConfirm()));
              }
              if (state is AdoptRequestError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (BuildContext context, Object? state) {
              return Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                    child: Column(
                      children: [
                        wdQuestion("Do you have another pet ?"),
                        Container(
                          padding: const EdgeInsets.fromLTRB(6, 6, 6, 3),
                          child: wdRadio(),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(anotherPetError,
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.red))),
                        Visibility(
                          visible: anotherPet == true,
                          child: Column(
                            children: [
                              wdQuestion("Are your pets friendly?"),
                              Container(
                                padding: const EdgeInsets.fromLTRB(6, 6, 6, 3),
                                child: wdMiddleRadio(),
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('$isFriendlyError',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: Colors.red))),
                            ],
                          ),
                        ),
                        wdQuestion("Do you have Kids?"),
                        Container(
                            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                            child: wdKidRadio()),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('$kidsError',
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.red))),
                        SizedBox(height: 15),
                        DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<int>(
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            style: const TextStyle(
                                color: Color(0xff000000), fontSize: 15),
                            validator: (value) {
                              if (value == null)
                                return "Please select your hometype.";
                              return null;
                            },
                            focusColor: Colors.white,
                            value: typeValue,
                            iconEnabledColor: Colors.black,
                            items: const [
                              DropdownMenuItem(
                                child: Text("Apartment"),
                                value: 1,
                              ),
                              DropdownMenuItem(child: Text("Villa"), value: 2)
                            ],
                            onChanged: (int? value) {
                              setState(() {
                                typeValue = value!;
                              });
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              fillColor: Color(0xFFE5E5E5),
                              labelText: 'Home Type',
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFF6F6F6), width: 0.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          maxLines: 8,
                          controller: _ctrlNote,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                    color: Color(0xFFE5E5E5), width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                    color: Color(0xFFE5E5E5), width: 2.0),
                              ),
                              hintText: 'Why do you want to adopt?',
                              fillColor: Color(0xFFE5E5E5),
                              filled: true),
                          keyboardType: TextInputType.multiline,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return ("Reason cannot be Empty");
                            }
                            if (value.trim().length < 10)
                              return ("Reason must be at least 10 characters");
                            if (value.trim().length > 100)
                              return ("Reason must be at most 100 characters");
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
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
                                pressed: () async {
                                  _formKey.currentState!.validate();
                                  if (!validate() ||
                                      !_formKey.currentState!.validate())
                                    return;
                                  else {
                                    BlocProvider.of<AdoptRequestBloc>(context)
                                        .add(
                                      AdoptRequestFunction(
                                          postID!,
                                          anotherPet!,
                                          isFriendly,
                                          hasKids!,
                                          typeValue!,
                                          _ctrlNote.text),
                                    );

                                    List<dynamic> tokens =
                                        await _fcmNotificationService.getUserToken(pet!.orgID);
                                    try {
                                      tokens.forEach((element) {
                                        print("array: " + element.toString());
                                        _fcmNotificationService
                                            .sendNotificationToUser(
                                          fcmToken: element.toString(),
                                          title: "New adoption request",
                                          body: "Pet: " + pet!.name,
                                        );
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Notification sent.'),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Error, ${e.toString()}.'),
                                        ),
                                      );
                                    }
                                  }
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
                  ));
            },
          ),
        ));
  }

  bool validate() {
    bool flag = true;
    if (anotherPet == null) {
      setState(() {
        anotherPetError = '* Missing Field';
        flag = false;
      });
    }
    if (anotherPet! && (isFriendly == -1)) {
      setState(() {
        isFriendlyError = '* Missing Field';
        flag = false;
      });
    }
    if (!anotherPet!) {
      setState(() {
        isFriendly = 2;
      });
    }

    if (hasKids == null) {
      setState(() {
        kidsError = '* Missing Field';
        flag = false;
      });
    }
    return flag;
  }
}
