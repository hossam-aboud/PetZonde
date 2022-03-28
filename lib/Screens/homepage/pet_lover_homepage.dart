import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petzone/ReqList/Request_form_Vet.dart';
import 'package:petzone/Screens/adoption/adoption_posts_list.dart';

import '../handovering/handovering_list.dart';
import '../lost_and_found/lost_and_found_list.dart';
import '../reminder/reminder_add.dart';
import '../requests_screen.dart';

class petLoverHomepage extends StatelessWidget {
  final _scrollController = ScrollController();

  petLoverHomepage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.height * 0.02),
        //logo
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
        SizedBox(height: size.height * 0.09),

        Padding(
          padding: EdgeInsets.only(left: 18.0),
          child: Text(
            'Services',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.teal[800],
                fontFamily: 'DM Sans',
                fontSize: 21,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
        ),

        //services
        Padding(
            padding: const EdgeInsets.all(5.0),
            child: Scrollbar(
                controller: _scrollController,
                isAlwaysShown: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      children: [
                        serviceWidget(
                            "Consultation",
                            AssetImage('assets/veterinary.png'),
                            context,
                            /* Next Page consultation() */ ReqVetList()),
                        serviceWidget(
                            "Adoption",
                            AssetImage('assets/adoption.png'),
                            context,
                            adoptionList()),
                        serviceWidget(
                            "Lost and Found",
                            AssetImage('assets/missingPet.png'),
                            context,
                            /* Next Page lostAndFound() */ lostAndFoundList()),
                        serviceWidget(
                            "Handover",
                            AssetImage('assets/handover.png'),
                            context,
                            /* Next page handover() */ const HandoveringOrgList()),
                        serviceWidget(
                            "Pet Sitting",
                            AssetImage('assets/petSitter.png'),
                            context,
                            /* Next page petSitting() */ ReqScreen()),
                        serviceWidget(
                            "Reminders",
                            AssetImage('assets/reminder.png'),
                            context,
                            /* Next Page reminders() */ AddReminderScreen()),
                      ],
                    ),
                  ),
                ))),

        SizedBox(height: size.height * 0.05),

        Padding(
          padding: EdgeInsets.only(left: 18.0),
          child: Text(
            'Upcoming Appointments',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.teal[800],
                fontFamily: 'DM Sans',
                fontSize: 21,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
        ),
        SizedBox(height: size.height * 0.02),

        //upcoming events(UI only)
        SingleChildScrollView(
          child: Container(
              width: 600,
              height: 139,
              child: Stack(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 450,
                    height: 140,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(226, 246, 240, 1),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Stack(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 97,
                          height: 118,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                  offset: Offset(0, 4),
                                  blurRadius: 4)
                            ],
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                          child: Column(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Dec',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(25, 25, 25, 1),
                                      fontFamily: 'DM Sans',
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                              ),
                              Text(
                                '17',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color.fromRGBO(25, 25, 25, 1),
                                    fontFamily: 'DM Sans',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    height: 1),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Wed',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(25, 25, 25, 1),
                                      fontFamily: 'DM Sans',
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                Center(
                    child: Container(
                        child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Text(
                        'Dr.Ahmed',
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
                            color: Color.fromRGBO(151, 151, 151, 1),
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
                )))
              ])),
        )
      ],
    );
  }

  Widget serviceWidget(
      String text, AssetImage image, BuildContext context, Widget nextPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => nextPage));
      },
      child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            width: 138,
            height: 169,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromRGBO(60, 160, 148, 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  )
                ]),
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
