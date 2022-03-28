library globals;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:petzone/Screens/CreditCardInfo.dart';
import 'package:petzone/model/LoginRequestData.dart';

import 'MedicalData.dart';
LoginRequestData loginRequestData=new LoginRequestData();
String firstBank="Riyad Bank";
String secondBank="Al Rajhi Bank";
String thirdBank="Bemo Bank";
List<GlobalKey<FormState>>? formKeys;



StreamController? isValidController=null;
MedicalData? medicaltData=null;