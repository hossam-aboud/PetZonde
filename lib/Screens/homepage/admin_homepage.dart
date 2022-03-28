
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class adminHomepage extends StatelessWidget {
  const adminHomepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.02),
          //logo
          Center(
            child: Container(
                width: 240,
                height: 99,
                decoration: const BoxDecoration(
                  image : DecorationImage(
                      image: AssetImage('assets/logo_width.png'),
                      fit: BoxFit.fitWidth
                  ),
                )
            ),
          ),
          SizedBox(height: size.height * 0.09),

          const Padding(
            padding: EdgeInsets.only(left: 18.0),
            child: Text('admin Services', textAlign: TextAlign.left, style: TextStyle(
                color: Color.fromRGBO(25, 25, 25, 1),
                fontFamily: 'DM Sans',
                fontSize: 21,
                fontWeight: FontWeight.normal,
                height: 1
            ),
            ),
          ),

          //services
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  serviceWidget("Consultation", AssetImage('assets/veterinary.png'), context, /* Next Page consultation() */),
                  serviceWidget("Adoption", AssetImage('assets/adoption.png'), context, /* Next Page Adoption() */),
                  serviceWidget("Lost and Found", AssetImage('assets/missingPet.png'), context, /* Next Page lostAndFound() */),
                  serviceWidget("Handover", AssetImage('assets/handover.png'), context, /* Next page handover() */),
                  serviceWidget("Pet Sitting", AssetImage('assets/petSitter.png'), context, /* Next page petSitting() */),
                  serviceWidget("Reminders", AssetImage('assets/reminder.png'), context, /* Next Page reminders() */),
                ],
              ),
            ),
          ),

          SizedBox(height: size.height * 0.05),

          const Padding(
            padding: EdgeInsets.only(left: 18.0),
            child: Text('Upcoming Events', textAlign: TextAlign.left, style: TextStyle(
                color: Color.fromRGBO(25, 25, 25, 1),
                fontFamily: 'DM Sans',
                fontSize: 21,
                fontWeight: FontWeight.normal,
                height: 1
            ),
            ),
          ),
          SizedBox(height: size.height * 0.02),

          //upcoming events(UI only)
          SingleChildScrollView(
            child: Container(
                width: 386,
                height: 139,

                child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: 386,
                          height: 140,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(226,246,240,1),
                            borderRadius : BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 97,
                                    height: 118,
                                    decoration: const BoxDecoration(
                                      borderRadius : BorderRadius.all(Radius.circular(20)),
                                      boxShadow : [BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.25),
                                          offset: Offset(0,4),
                                          blurRadius: 4
                                      )],
                                      color : Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                    child: Column(
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text('Dec', textAlign: TextAlign.left, style: TextStyle(
                                              color: Color.fromRGBO(25, 25, 25, 1),
                                              fontFamily: 'DM Sans',
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                              height: 1
                                          ),),
                                        ),
                                        Text('17', textAlign: TextAlign.left, style: TextStyle(
                                            color: Color.fromRGBO(25, 25, 25, 1),
                                            fontFamily: 'DM Sans',
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            height: 1
                                        ),),
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text('Wed', textAlign: TextAlign.left, style: TextStyle(
                                              color: Color.fromRGBO(25, 25, 25, 1),
                                              fontFamily: 'DM Sans',
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                              height: 1
                                          ),),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ),
                      Center(
                          child: Container(
                              child:
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0,20,0,20),
                                    child: Text('Dr.Ahmed', textAlign: TextAlign.left, style: TextStyle(
                                        color: Color.fromRGBO(25, 25, 25, 1),
                                        fontFamily: 'DM Sans',
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                        height: 1
                                    ),),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0,0,0,5),
                                    child: Text('Sceduled time', textAlign: TextAlign.left, style: TextStyle(
                                        color: Color.fromRGBO(151, 151, 151, 1),
                                        fontFamily: 'DM Sans',
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                        height: 1
                                    ),),
                                  ),
                                  Text('12:30 pm', textAlign: TextAlign.left, style: TextStyle(
                                      color: Color.fromRGBO(25, 25, 25, 1),
                                      fontFamily: 'DM Sans',
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      height: 1
                                  ),)
                                ],
                              )
                          )
                      )

                    ]
                )
            ),
          )
        ],
      );
  }

  Widget serviceWidget(String text, AssetImage image, BuildContext context, /*Widget nextPage*/){
    return GestureDetector(
      onTap: (){

      },
      child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            width: 138,
            height: 169,
            decoration: BoxDecoration(borderRadius : BorderRadius.all(Radius.circular(20)),
              color : Color.fromRGBO(37, 173, 148, 1),
            ),
            child: Column(
              children: [
                Container(
                    width: 102,
                    height: 120,
                    decoration: BoxDecoration(
                      image : DecorationImage(
                          image: image,
                          fit: BoxFit.fitWidth
                      ),
                    )
                ),
                Container(
                  width: 136,
                  height: 48,
                  decoration: const BoxDecoration(
                    borderRadius : BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color : Color.fromRGBO(255, 255, 255, 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(text, textAlign: TextAlign.center, style: const TextStyle(
                        color: Color.fromRGBO(25, 25, 25, 1),
                        fontFamily: 'DM Sans',
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        height: 1
                    ),),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
