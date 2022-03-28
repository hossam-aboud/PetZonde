import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class vetHomepage extends StatelessWidget {
  const vetHomepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    String getuser() {
      User? user = FirebaseAuth.instance.currentUser;
      return user!.uid.toString();
    }

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('veterinarian')
            .where('uid', isEqualTo: getuser())
            .snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.02),
                    SizedBox(height: size.height * 0.03),
                    Center(
                      child: Container(
                          width: 240,
                          height: 99,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/logo_width.png'),
                                fit: BoxFit.fitWidth),
                          )),
                    ),
                    SizedBox(height: size.height * 0.03),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hi, Dr.',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xFF515255),
                              fontFamily: 'DM Sans',
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              height: 1),
                        ),
                        Text(
                          (snapshot.data!).docs[index]['first name'] +
                              " " +
                              (snapshot.data!).docs[index]['last name'],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xFF03989E),
                              fontFamily: 'DM Sans',
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              height: 1),
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.09),

                    Padding(
                      padding: EdgeInsets.only(left: 18.0),
                      child: Row(
                        children: [
                          Text(
                            'Upcoming Appointments ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color(0xFF515255),
                                fontFamily: 'DM Sans',
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                          //SizedBox(width: size.width *0.1),
                          Text(
                            'Today',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.teal[300],
                                fontFamily: 'DM Sans',
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),

                    //upcoming events(UI only)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Container(
                            width: size.width,
                            height: size.height * 0.2,
                            child: Stack(children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  width: size.width,
                                  height: 140,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(226, 246, 240, 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Row(
                                    children: [
                                      Stack(children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(20.0),
                                                child: Icon(
                                                  Icons.person,
                                                  color: Color(0xFF03989E),
                                                  size: 40,
                                                ),
                                              )),
                                        ),
                                      ]),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: const [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                                  child: Text(
                                                    'Sara',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(25, 25, 25, 1),
                                                        fontFamily: 'DM Sans',
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.normal,
                                                        height: 1),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                                  child: Text(
                                                    'Sceduled time',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color:
                                                        Color.fromRGBO(151, 151, 151, 1),
                                                        fontFamily: 'DM Sans',
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.normal,
                                                        height: 1),
                                                  ),
                                                ),
                                                Text(
                                                  '12:30 pm',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(25, 25, 25, 1),
                                                      fontFamily: 'DM Sans',
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.normal,
                                                      height: 1),
                                                )
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ),

                            ])),
                      ),
                    )
                  ],
                );
              });
        });
  }

  Widget serviceWidget(
    String text,
    AssetImage image,
    BuildContext context,
    /*Widget nextPage*/
  ) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            width: 138,
            height: 169,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color.fromRGBO(37, 173, 148, 1),
            ),
            child: Column(
              children: [
                Container(
                    width: 102,
                    height: 120,
                    decoration: BoxDecoration(
                      image:
                          DecorationImage(image: image, fit: BoxFit.fitWidth),
                    )),
                Container(
                  width: 136,
                  height: 48,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Color.fromRGBO(25, 25, 25, 1),
                          fontFamily: 'DM Sans',
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
