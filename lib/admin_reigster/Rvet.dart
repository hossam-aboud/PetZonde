//import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Rvet extends StatelessWidget {
  const Rvet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        body:  Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                SizedBox(height: 30.0),
                SizedBox(height: size.height * 0.05),
                Container(
                  child: Image.asset(
                    "assets/logo_full.png",
                    height: size.height * 0.25,
                  ),
                ),

                _email(),
                _phone(),
                _Password(),
                _PasswordConf(),
                SizedBox(height: size.height * 0.03),
                _NextButton(context),
                SizedBox(height: size.height * 0.05),


              ],)


        ));

  }
}
Widget _email(){
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
          hintText: "Enter your email" ,
        ),
      ));
}
Widget _phone(){
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
            hintText: "Enter your phone number"
        ),
      ));
}
Widget _Password(){
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
            hintText: "Enter password"
        ),
      ));
}
Widget _PasswordConf(){
  return  Padding(padding: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 20.0)  ,
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
              borderSide: BorderSide(color:  Color(0xFFF6F6F6), width: 2.0),
            ),
            hintText: "Confirm password"
        ),
      ));

}

Widget _NextButton(BuildContext context){
  return ElevatedButton(
    onPressed:(){
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new Rvet2()),
      );
    },
    child: Padding(
        padding: EdgeInsets.only(left: 25.0 , right:25.0 , top: 10 , bottom: 10),
        child: Text('Next',  style: TextStyle( fontSize: 20 ))),
    style: ButtonStyle(
      backgroundColor:  MaterialStateProperty.all<Color>(Color(0xFFF88A8A)),
    ) ,
  );
}
class Rvet2 extends StatelessWidget {
  const Rvet2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        body:  Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                SizedBox(height: 30.0),
                SizedBox(height: size.height * 0.05),
                Container(
                  child: Image.asset(
                    "assets/logo_full.png",
                    height: size.height * 0.25,
                  ),
                ),

                fname(),
                lname(),
                experience(),
                speciality(),
                SizedBox(height: size.height * 0.03),
                _NextButton1(context),
                SizedBox(height: size.height * 0.05),


              ],)


        ));

  }
}
Widget fname(){
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
          hintText: "Enter your first name" ,
        ),
      ));
}
Widget lname(){
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
            hintText: "Enter your last name"
        ),
      ));
}
Widget experience(){
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
            hintText: "Enter your experience in detail"
        ),
      ));
}
Widget speciality(){
  return  Padding(padding: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 20.0)  ,
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
              borderSide: BorderSide(color:  Color(0xFFF6F6F6), width: 2.0),
            ),
            hintText: "enter your speciality"
        ),
      ));

}

Widget _NextButton1(BuildContext context){
  return ElevatedButton(
    onPressed:(){
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new Rvet2()),
      );
    },
    child: Padding(
        padding: EdgeInsets.only(left: 25.0 , right:25.0 , top: 10 , bottom: 10),
        child: Text('Next',  style: TextStyle( fontSize: 20 ))),
    style: ButtonStyle(
      backgroundColor:  MaterialStateProperty.all<Color>(Color(0xFFF88A8A)),
    ) ,
  );
}



