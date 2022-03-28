import 'package:flutter/material.dart';

import '../constants.dart';
import 'package:petzone/model/globals.dart' as globals;
class CreateCreditInfo extends StatefulWidget{
  GlobalKey<FormState> formKey;
  CreateCreditInfo(this.formKey);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CreateCreditInfoFormState();
  }

}
class CreateCreditInfoFormState extends State<CreateCreditInfo>{
  final GlobalKey<FormState> _key = GlobalKey();
  bool _obscureText = true;

  int? _value ;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // TODO: implement build
    return SingleChildScrollView(
      child: Column(
        key: widget.formKey,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(15, 1, 15, 1),
            child: Form(
              key: _key,
              child: _getFormUI(size),
            ),
          ),
        ],
      ),
    );
  }
  Widget _getFormUI(Size size) {
    if(globals.loginRequestData.bankValue!=-1)
    {
      _value=globals.loginRequestData.bankValue;
    }
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Bank Details",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black),
          ),
        ),
        const SizedBox(height: 20.0),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left:30.0),
            child: Text(
              "Card Holder Name:",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 5.0),
        TextFormField(
          initialValue: globals.loginRequestData.cardHolderName,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: InputDecoration(
            fillColor: Colors.grey.shade300,
            filled: true,
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: Colors.white, width: 1.0)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: Colors.white, width: 1.0)),
          ),

          onChanged: (value) {
            globals.loginRequestData.cardHolderName  = value;
          },
        ),
        const SizedBox(height: 20.0),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left:30.0),
            child: Text(
              "Bank Name:",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
            ),
          ),),
        const SizedBox(height: 5.0),
        Container(
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey.shade300,
          ),

          child:Center(
            child: DropdownButton(
              // style: TextStyle(color: Colors.white),
                iconEnabledColor:DeclineButton,
                underline: SizedBox(),
                value: _value,
                items: [
                  DropdownMenuItem(
                    child: Text(globals.firstBank),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text(globals.secondBank),
                    value: 2,
                  ),
                  DropdownMenuItem(
                    child: Text(globals.thirdBank),
                    value: 3,
                  )
                ],

                onChanged: (int? value) {
                  _value=value!;
                  globals.loginRequestData.bankValue=value;
                  setState(() {

                    if(_value==1)
                    {
                      globals.loginRequestData.bankName=globals.firstBank;
                    }
                    else if(_value==2)
                    {
                      globals.loginRequestData.bankName=globals.secondBank;
                    }
                    else
                    {
                      globals.loginRequestData.bankName=globals.thirdBank;
                    }
                  });
                } ,
                hint:Text("Select a Bank")
            ),
          ),
        )
        ,



        const SizedBox(height: 20.0),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left:30.0),
            child: Text(
              "IBAN number",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
            ),
          ),),
        const SizedBox(height:5.0),
        TextFormField(
          initialValue: globals.loginRequestData.IBanNumber,
          keyboardType: TextInputType.name,
          autofocus: false,
          decoration: InputDecoration(

            fillColor: Colors.grey.shade300,
            filled: true,
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: const BorderSide(color: Colors.white, width: 1.0)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: const BorderSide(color: Colors.white, width: 1.0)),
          ),

          onChanged: (value) {
            globals.loginRequestData. IBanNumber= value;
          },
        ),
        const SizedBox(height: 20.0),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left:30.0),
            child: Text(
              "Consultation Price (SR)",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
            ),
          ),),
        const SizedBox(height:5.0),
        TextFormField(
          initialValue: globals.loginRequestData.consultPrice.toString(),
          keyboardType: TextInputType.number,
          autofocus: false,
          decoration: InputDecoration(

            fillColor: Colors.grey.shade300,
            filled: true,
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: const BorderSide(color: Colors.white, width: 1.0)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: const BorderSide(color: Colors.white, width: 1.0)),
          ),

          onChanged: (value) {
            globals.loginRequestData.consultPrice =double.parse(value);
          },
        ),
        const SizedBox(height: 20.0),


      ],
    );
  }


}