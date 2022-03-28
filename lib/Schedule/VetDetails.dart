import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/custom_button.dart';
import 'SendVetRequest.dart';

class VetDetailss extends StatefulWidget {
  DocumentSnapshot vet;
  VetDetailss({required this.vet});

  @override
  State<VetDetailss> createState() => _VetDetailssState(vet: vet);
}

class _VetDetailssState extends State<VetDetailss> {
  DocumentSnapshot vet;

  _VetDetailssState({required this.vet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Color(0xffD0F1EB),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Veterinarian Profile",
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
        body: Stack(alignment: Alignment.topCenter, children: [
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
                    vet['first name'] + ' ' + vet['last name'],
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
                      image: vet['photoUrl'] == null
                          ? AssetImage("assets/defaultpfp.png")
                          : Image.network(vet['photoUrl']).image,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        child: Row(children: <Widget>[
                          Flexible(
                            child: new Container(
                              child: new Text(
                                'Degree: ' + vet['degree'],
                                overflow: TextOverflow.fade,
                                style: new TextStyle(
                                    fontStyle: FontStyle.normal,
                                    color: Color(0xff656F77),
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(height: 15),
                      Container(
                        child: Row(children: <Widget>[
                          Flexible(
                            child: new Container(
                              child: new Text(
                                'Speciality: ' + vet['speciality'],
                                overflow: TextOverflow.fade,
                                style: new TextStyle(
                                    fontStyle: FontStyle.normal,
                                    color: Color(0xff656F77),
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(height: 15),
                      Container(
                        child: Row(children: <Widget>[
                          Flexible(
                            child: new Container(
                              child: new Text(
                                'Experience: ' + vet['experience'],
                                overflow: TextOverflow.fade,
                                style: new TextStyle(
                                    fontStyle: FontStyle.normal,
                                    color: Color(0xff656F77),
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(height: 15),
                      Container(
                        child: Row(children: <Widget>[
                          Text(
                            'Email: ' + vet['email'],
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                color: Color(0xff656F77),
                                fontSize: 18),
                          )
                        ]),
                      ),
                      SizedBox(height: 15),
                      Container(
                        child: Row(children: <Widget>[
                          Text('Phone: ' + vet['phone'],
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  color: Color(0xff656F77),
                                  fontSize: 18)),
                        ]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 45),
                Container(
                  child: Center(
                      child: CustomButton(
                          text: 'Consult',
                          textSize: 20,
                          textColor: Colors.white,
                          color: PrimaryButton,
                          size:
                              Size(MediaQuery.of(context).size.width * 0.5, 55),
                          pressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SendVetRequest(
                                          vet: vet,
                                        )));
                          })),
                )
              ],
            ),
          )
        ]));
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
