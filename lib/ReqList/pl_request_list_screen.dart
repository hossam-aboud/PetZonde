import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/ReqList/Repository.dart';
import 'package:petzone/ReqList/reqBloc.dart';
import 'package:petzone/model/adoption_post.dart';

import '../Screens/adoption/adoption_post_detail.dart';
import '../Screens/vet_requests/pet_lover/consult_request_list.dart';
import '../constants.dart';
import '../widgets/custom_dialog.dart';
import 'Request_form.dart';
import 'handover_request.dart';

class PetLoverRequestList extends StatefulWidget {
  const PetLoverRequestList({Key? key}) : super(key: key);

  @override
  _PetLoverRequestList createState() => _PetLoverRequestList();
}

class _PetLoverRequestList extends State<PetLoverRequestList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "My Requests",
            style: TextStyle(
              color: Colors.teal[800],
            ),
          ),
        ),
        body: ListView(
          physics: NeverScrollableScrollPhysics(), //<--here
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            ListTile(size, 'Vet Consultation', 'assets/sickdog.png',
                PlConsultRequests()),
            ListTile(size, 'Adoption', 'assets/adopt.png', ReqFormPL()),
            ListTile(size, 'Handover', 'assets/share.png', PlHandoverRequest()),
            ListTile(size, 'Pet Sitting', 'assets/dog-house.png', null),
            /* Naming needs to be reconsidered.
            ListTile(size, 'Sent Pet Sitting Requests',
                'assets/paper-plane.png', ReqFormPL()) */
          ],
        ));
  }

  Widget ListTile(Size size, String title, String image, requestPage) {
    return GestureDetector(
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    PrimaryLightButton,
                    Colors.white,
                    Colors.white,
                    Colors.white,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Container(
                            width: size.width * 0.19,
                            height: size.height * 0.1,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(image),
                                  fit: BoxFit.fitWidth),
                            )),
                      ),
                      const SizedBox(width: 20),
                      Text(title,
                          style: TextStyle(
                            color: TextColor,
                            fontSize: 22.0,
                          )),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                  )
                ],
              ))),
      onTap: () {
        if (requestPage != null)
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => requestPage));
      },
    );
  }
}
