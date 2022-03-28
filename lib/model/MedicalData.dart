import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class MedicalData {
  String name = '';
  String passport_ID = '';
  String gender = '';
  String age = '';
  String breed = '';
  String cat_or_dog = '';
  String? imgUrl;
  String stersllized = '';
  String? vaccination_url;
  String? medical_history_url;
  String vaccinated = '';
  String uid = '';

  List<PlatformFile>? paths;
  List<PlatformFile>? injections;
  XFile? petImg;
}
