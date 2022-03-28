// ignore: file_names
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:petzone/bloc/registerProfile/register_profile_bloc.dart';
import 'package:petzone/model/UserRegister.dart';
import 'package:petzone/repositories/admin_repository.dart';
import 'package:petzone/widgets/custom_dialog.dart';
import 'package:petzone/widgets/profile.dart';
import '../../model/poster.dart';
import '../../widgets/custom_button.dart';
import '../../constants.dart';
import 'handovering_send_request.dart';

class HandoveringOrgProfile extends StatefulWidget {
  final Poster org;
  final bool? viewOnly;

  const HandoveringOrgProfile({Key? key, required this.org, this.viewOnly})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _HandoveringOrgProfile();
}

class _HandoveringOrgProfile extends State<HandoveringOrgProfile> {
  late Poster org;
  late bool viewOnly;
  @override
  void initState() {
    super.initState();
    org = widget.org;
    viewOnly = widget.viewOnly ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Color(0xffD0F1EB),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.teal[800],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            CustomPaint(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              painter: HeaderCurvedContainer(),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      org.name,
                      style: TextStyle(
                        fontSize: 35,
                        letterSpacing: 1.5,
                        color: TextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    width: MediaQuery.of(context).size.width / 1.25,
                    height: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 5),
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: org.img == null
                            ? AssetImage("assets/defaultpfp.png")
                            : Image.network(org.img!).image,
                      ),
                    ),
                  ),
                  Column(children: <Widget>[
                    ListTile(
                      minLeadingWidth: 0,
                      leading: Text('City:', style: TextStyle(fontSize: 18)),
                      title: Text(org.city!, style: TextStyle(fontSize: 18)),
                    ),
                    ListTile(
                      title: Text('Website:', style: TextStyle(fontSize: 18)),
                      subtitle:
                          Text(org.website!, style: TextStyle(fontSize: 18)),
                    ),
                    ListTile(
                      title:
                          Text('Description:', style: TextStyle(fontSize: 18)),
                      subtitle: Text(org.description!,
                          style: TextStyle(fontSize: 18)),
                    ),
                  ]),
                  SizedBox(
                    height: 50,
                  ),
                  Visibility(
                      visible: !viewOnly,
                      child: Container(
                          child: CustomButton(
                              text: 'Handover a Pet',
                              textSize: 20,
                              textColor: Colors.white,
                              color: PrimaryButton,
                              size: Size(
                                  MediaQuery.of(context).size.width * 0.6, 55),
                              pressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SendHandoverRequest(
                                                orgID: org.id)));
                              })))
                ],
              ),
            )
          ],
        ));
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xffD0F1EB);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 100, size.width, 140)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
