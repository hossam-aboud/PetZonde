import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../NewSchedule/Days.dart';
import '../Schedule/SetSchedule.dart';
import '../bloc/auth/auth_bloc.dart';
import '../constants.dart';

User? user = FirebaseAuth.instance.currentUser;

class ProfileViewVet extends StatefulWidget {
  const ProfileViewVet({Key? key}) : super(key: key);

  @override
  _ProfileViewVetState createState() => _ProfileViewVetState();
}

DocumentReference ownerVet =
    FirebaseFirestore.instance.collection('veterinarian').doc(user!.uid);

DocumentReference userRef =
    FirebaseFirestore.instance.collection('users').doc(user!.uid);

class _ProfileViewVetState extends State<ProfileViewVet> {
  @override
  String getuser() {
    User? user = FirebaseAuth.instance.currentUser;
    return user!.uid.toString();
  }

  final fnameController = TextEditingController();
  final lnameController = TextEditingController();

  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final speController = TextEditingController();
  final expController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "\t Profile",
                style: TextStyle(color: Colors.teal[800], fontSize: 20),
              ),
              SizedBox(width: 90),
              IconButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(
                      SignOutRequested(),
                    );
                  },
                  icon: Icon(Icons.logout, color: Colors.black54, size: 30))
            ],
          ),
          // leading: GestureDetector(
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          //   child: Icon(
          //     Icons.arrow_back,
          //     color: Colors.teal[800],
          //   ),
          // ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('veterinarian')
                    .where("uid", isEqualTo: getuser())
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text(' ');
                  if (snapshot.data!.docs.isEmpty ||
                      snapshot.data!.docs == null) {
                    return Container(
                        padding: EdgeInsets.only(left: 25, right: 25, top: 20),
                        child: Text(getuser(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.grey),
                            textAlign: TextAlign.center));
                  }
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.only(
                                left: 0.0, right: 0.0, bottom: 35.0, top: 30),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  secound(
                                      context, (snapshot.data!).docs[index]),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 35.0,
                                        right: 35.0,
                                        bottom: 35.0,
                                        top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "your information is updated successfully "),
                                                backgroundColor: Colors.green,
                                              ),
                                            );

                                            (snapshot.data!)
                                                .docs[index]
                                                .reference
                                                .update({
                                              'first name':
                                                  fnameController.text,
                                              'last name': lnameController.text,
                                              'email': emailController.text,
                                              'phone': phoneController.text,
                                              'experience': expController.text,
                                              'speciality': speController.text,
                                            }).catchError((error) => print(
                                                    "Failed to update user your information : $error"));
                                            FirebaseAuth.instance.currentUser!
                                                .updateEmail(
                                                    emailController.text)
                                                .catchError((error) => print(
                                                    "Failed to update user email : $error"));

                                            userRef.update({
                                              'email': emailController.text
                                            }).catchError((error) => print(
                                                "Failed to update user email : $error"));
                                          },
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 34.0,
                                                  right: 34.0,
                                                  top: 10,
                                                  bottom: 10),
                                              child: Text('Save',
                                                  style:
                                                      TextStyle(fontSize: 20))),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(AcceptButton),
                                          ),
                                        ),
                                        SizedBox(width: 13),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ScheduleUI()));
                                          },
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                              ),
                                              child: Text(
                                                'Set Schedule',
                                                style: TextStyle(fontSize: 20),
                                                maxLines: 3,
                                                softWrap: false,
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all<
                                                    EdgeInsetsGeometry>(
                                                EdgeInsets.only(
                                                    right: 5, left: 10)),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(AcceptButton),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]));
                      });
                })));
  }

  Widget secound(BuildContext context, ownerVet) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(children: <Widget>[
        CircleAvatar(
            backgroundColor: Colors.grey[400],
            radius: 80,
            backgroundImage: ownerVet['photoUrl'] != null
                ? Image.network(ownerVet['photoUrl'].toString()).image
                : AssetImage("assets/defaultpfp.png")),
        SizedBox(height: 15),
        TextFields(ownerVet, 'first name', fnameController),
        TextFields(ownerVet, 'last name', lnameController),
        TextFields(ownerVet, 'email', emailController),
        TextFields(ownerVet, 'phone', phoneController),
        TextFields(ownerVet, 'experience', expController),
        TextFields(ownerVet, 'speciality', speController),
        SizedBox(height: 15),
      ]),
    );
  }

  Widget TextFields(DocumentSnapshot<Object?> ownerVet, String att,
      TextEditingController controller) {
    controller.text = ownerVet[att];
    String label = att[0].toUpperCase() + att.substring(1);

    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
        child: TextFormField(
          maxLines: (att == 'experience' || att == 'speciality' ? 5 : 1),
          style: TextStyle(color: Colors.black54),
          autofocus: false,
          controller: controller,
          decoration: InputDecoration(
              labelText: label,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
              ),
              hintText: att),
        ));
  }
}

ButtonStyle backButton = ElevatedButton.styleFrom(
    shape: CircleBorder(),
    padding: EdgeInsets.all(20),
    primary: Colors.transparent,
    shadowColor: Colors.transparent);

class navKeys {
  static final globalKey = GlobalKey();
  static final globalKeyAdmin = GlobalKey();
}
