import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class LoginRequestData {
  String email = '';
  String firstName = '';
  String lastName = '';
  String password = '';
  String confirm = '';
  String phoneNumber = '';
  String experience = '';
  String speciality = '';
  String degree = '';
  String cardHolderName = '';
  String bankName = '';
  int bankValue=-1;
  String IBanNumber = '';
  double consultPrice = 0;
  XFile? imageFile;
  List<PlatformFile>? paths;
  String profileUrl='';
  String degreeUrl='';
}