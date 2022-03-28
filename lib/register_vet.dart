//import 'dart:html';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class register_vet extends StatefulWidget{
  @override
  register_vetstate createState()=>register_vetstate();
}
class register_vetstate extends State<register_vet> {


        @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        body:  SingleChildScrollView(
child:
        Center(

              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
             //  Container(

             //     child: Image.asset(
             //      "assets/logo_full.png",
               //    height: size.height * 0.15,
                 // ),
             //   ),

                name(),
                dob(),
                breed(),
                passportid(),

                Medicalhistory(),
                vaccination(),
                _buildEventType2(),
                _buildEventType(),

                SizedBox(height: size.height * 0.03),
                _NextButton(context),
                SizedBox(height: size.height * 0.05),


              ],)


          ),),);


  }





}


Widget name(){
  return Padding(padding: EdgeInsets.all(20.0) ,
      child: TextFormField(
        decoration: InputDecoration(
          filled:true,
          fillColor: Color(0xFFF6F6F6),
          focusedBorder: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(

            borderRadius: new BorderRadius.circular(25.0),
            borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
          ),
          hintText: "name" ,
        ),
      ));
}
Widget dob(){
  return  Padding(padding:EdgeInsets.only(left: 20.0,right: 20.0,bottom: 20.0) ,
      child: TextFormField(
        decoration: InputDecoration(
            filled:true,
            fillColor: Color(0xFFF6F6F6),
            focusedBorder: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: BorderSide(color:  Color(0xFFF6F6F6), width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: BorderSide(color:  Color(0xFFF6F6F6), width: 2.0),
            ),
            hintText: "Date of Birth"
        ),
      ));
}
Widget breed(){
  return  Padding(padding:EdgeInsets.only(left: 20.0,right: 20.0,bottom: 20.0) ,
      child: TextFormField(
        decoration: InputDecoration(
          filled:true,
          fillColor: Color(0xFFF6F6F6),
          focusedBorder: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(

            borderRadius: new BorderRadius.circular(25.0),
            borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
          ),
          hintText: "breed" ,
        ),
      ));
}
Widget passportid(){
  return  Padding(padding:EdgeInsets.only(left: 20.0,right: 20.0,bottom: 20.0) ,
      child: TextFormField(
        decoration: InputDecoration(
            filled:true,
            fillColor: Color(0xFFF6F6F6),
            focusedBorder: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: BorderSide(color:  Color(0xFFF6F6F6), width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: BorderSide(color:  Color(0xFFF6F6F6), width: 2.0),
            ),
            hintText: "passport ID"
        ),
      ));
}
Widget Medicalhistory(){
  return  Padding(padding: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 20.0) ,
      child: TextFormField(

        decoration: InputDecoration(
            filled:true,
            fillColor: Color(0xFFF6F6F6),
            focusedBorder: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: BorderSide(color:  Color(0xFFF6F6F6), width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: BorderSide(color:  Color(0xFFF6F6F6), width: 2.0),
            ),
            hintText: "Medical history"
        ),
      ));
}
Widget vaccination(){

  return  Padding(padding: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 20.0) ,
      child: TextFormField(

        decoration: InputDecoration(
            filled:true,
            fillColor: Color(0xFFF6F6F6),
            focusedBorder: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: BorderSide(color:  Color(0xFFF6F6F6), width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: BorderSide(color:  Color(0xFFF6F6F6), width: 2.0),
            ),
            hintText: "vaccination"
        ),
      ));
}


int selectedValue=1;
Widget _buildEventType() {


  return Stack(
    children: [
      Container(  padding: const EdgeInsets.only(top: 20.0,left: 30),  child: Text('gender',style:const TextStyle(
          fontSize: 18,
          color: Color(0xff474343),
          fontFamily: 'Georgia'),),color:Color(0xFFF6F6F6) ,),
      Container(
        margin: EdgeInsets.only(left: 100),
        child:
        RadioListTile<int>(

            value: 1,
            title: Text(
              "male",
              style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xff334856),
                  fontFamily: 'Tajawal'),
            ),
            activeColor: Color(0xffe7cc2e),
            groupValue: selectedValue,
            onChanged: (val) {
              //  setState(() {
              //   selectedValue = val!;
              // });
            }),),
      Container(
        margin: EdgeInsets.only(left: 200),
        child: RadioListTile<int>(
            value: 2,
            groupValue: selectedValue,
            title: Text(
              "female",
              style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xff334856),
                  fontFamily: 'Tajawal'),
            ),
            activeColor: Color(0xffe7cc2e),
            onChanged: (val) {

              selectedValue = val!;
            }
        ),
      )
    ],
  );
}
Widget _buildEventType2() {


  return Stack(
    children: [

  Container(  padding: const EdgeInsets.only(top: 20.0,left: 30), child: Text('pet',style:const TextStyle(
  fontSize: 20,
  color: Color(0xff474343),
  fontFamily: 'Georgia'),
  ), ),
   Container(
     margin: EdgeInsets.only(left: 100),
     child:
      RadioListTile<int>(

          value: 1,
          title: Text(
            "cat",
            style: const TextStyle(
                fontSize: 20,
                color: Color(0xff474343),
                fontFamily: 'Georgia'),
          ),
          activeColor: Color(0xffe7cc2e),
          groupValue: selectedValue,
          onChanged: (val) {
            //  setState(() {
            //   selectedValue = val!;
            // });
          }),),
      Container(
        margin: EdgeInsets.only(left: 200),
        child: RadioListTile<int>(
            value: 2,
            groupValue: selectedValue,
            title: Text(
              "dog",
              style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xff1a2024),
                  fontFamily: 'Tajawal'),
            ),
            activeColor: Color(0xffe7cc2e),
            onChanged: (val) {

              selectedValue = val!;
            }
        ),
      )
    ],
  );
}




Widget _NextButton(BuildContext context){
  return ElevatedButton(
    onPressed:(){
     // Navigator.push(
     //   context,
       // new MaterialPageRoute(builder: (context) => new PLReg2()),
      //);
    },
    child: Padding(
        padding: EdgeInsets.only(left: 25.0 , right:25.0 , top: 10 , bottom: 10),
        child: Text('add pet',  style: TextStyle( fontSize: 20 ))),
    style: ButtonStyle(
      backgroundColor:  MaterialStateProperty.all<Color>(Color(0xFFF88A8A)),
    ) ,
  );}












