import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petzone/Screens/adoption/org_adpoption_post_list.dart';
import 'package:petzone/Screens/lost_and_found/lost_and_found_add.dart';

import '../lost_and_found/lost_and_found_list.dart';



class orgHomepage extends StatelessWidget {

  const orgHomepage({Key? key}) : super(key: key);

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
                image : DecorationImage(
                    image: AssetImage('assets/logo_width.png'),
                    fit: BoxFit.fitWidth
                ),
              )
          ),
        ),
        SizedBox(height: size.height * 0.09),

        SizedBox(height: size.height * 0.03),

        //services
        Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [

                    serviceWidget("Adoption Post", AssetImage('assets/adoption.png'), context, orgAdoptionList(), size),
                   SizedBox(height: size.height * 0.02),
                    serviceWidget("Lost and Found", AssetImage('assets/missingPet.png'), context, lostAndFoundList()/* Next Page lostAndFound() */, size),
              ],
            ),
          ),
        ),

        SizedBox(height: size.height * 0.05),

        SizedBox(height: size.height * 0.02),



      ],
    );

  }

  Widget serviceWidget(String text, AssetImage image, BuildContext context, Widget nextPage, Size size){
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  nextPage));
      },
      child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            width: size.width,
            height: size.height * 0.2,
            decoration: BoxDecoration(borderRadius : BorderRadius.all(Radius.circular(20)),
              color : Color.fromRGBO(60, 160, 148, 1),
                boxShadow: [BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0,3),
                )]
            ),
            child: Column(
              children: [
                Container(
                    width: 102,
                    height: size.height * 0.157,
                    decoration: BoxDecoration(
                      image : DecorationImage(
                          image: image,
                          fit: BoxFit.fitWidth
                      ),
                    )
                ),
                Container(
                  width: size.width * 0.91,
                  height: size.height * 0.043,
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