//addPetScreen
import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:image_picker/image_picker.dart';
import '../constants.dart';
import '../model/MedicalData.dart';
import '../register_vet.dart';
import 'package:petzone/model/globals.dart' as globals;

import '../service/authentication_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/helper.dart';
import 'PetsListPage.dart';


class addPetScreen extends StatefulWidget {
  const addPetScreen({Key? key}) : super(key: key);


  @override
  addPetScreenState createState() => addPetScreenState();
}

class addPetScreenState extends State<addPetScreen> {
  TextEditingController nameController= TextEditingController();
  TextEditingController passportController= TextEditingController();
  TextEditingController medicalController= TextEditingController();
  TextEditingController vaccinationController= TextEditingController();
  TextEditingController breedController= TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  List<Image>? imageFileList = [];
  int _current = 0;
  final CarouselController _controller = CarouselController();
  final _globalkey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _petPhoto;
  String age='';
  bool fChoice=false, mChoice = false,
      isVacc = false, isSet = false,
      notVacc = false, notSet = false,
      isCat = false, isDog = false;



  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // photo, name, description, age, city. gender, vacc, set,

    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Add Pet",
            style: TextStyle(
              color: Colors.teal[800],
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.teal[800],
            ),
          ),
        ),
        body:
        SingleChildScrollView(child:
        Column(
          children: [
            GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheet()),
                  );
                },
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey,
                  backgroundImage: _petPhoto == null
                      ? AssetImage("assets/pet_profile_picture.png")
                      : Image.file(
                    File(_petPhoto!),
                    fit: BoxFit.cover,
                  ).image,
                  child: Stack(children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor:
                        DeclineButton.withOpacity(0.7),
                        child:
                        Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ]),
                )),
            SizedBox(height: 15),

            nameField("Pet's Name",nameController,1),
            SizedBox(height: 15),
            nameField("Passport ID (optional)",passportController,2),
            SizedBox(height: 15),

            nameField("Pet's Breed",breedController,3),

            SizedBox(height: 15),
            ListTile(

              title: Container(child:Text('Pet\'s Age', style: TextStyle(fontWeight: FontWeight.bold, color: TextColor))),
              subtitle:  Container(
                  width: double.infinity,
                  height: 55,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.circular(25.0),
                    color: FieldColor,
                  )),
                  onTap: () {
                    showPicker(context);
                  },
                ),

            SizedBox(height: 20),
            Column(
              children: [
                ListTile(
                  title: Text('Gender', style: TextStyle(fontWeight: FontWeight.bold, color: TextColor),),
                  subtitle: Container(
                    width: double.infinity,
                    height: 60,
                    padding: const EdgeInsets.only(top: 10),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: double.infinity,
                        child: Card(
                          semanticContainer: true,
                          color: fChoice ? Color(0xFFFF71AF) : Color(0xFFE5E5E5) ,
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                fChoice = true;
                                mChoice = false;
                              });

                                },

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,

                                  children: [
                                    /*
                                   Image(image: fChoice?
                                    Image.asset('assets/female-white.png').image
                                        :
                                    Image.asset('assets/female.png').image),
                                    */
                                    fChoice?Icon(Icons.female,color: Colors.white,):Icon(Icons.female,color: Colors.black54,),
                                    Text('Female', style: TextStyle(color: fChoice? Colors.white : TextColor,fontWeight: FontWeight.bold, fontSize: 16)),
                                    SizedBox(width: 5,)
                                  ],),

                              ),


                            )

                        ),

                        SizedBox(width: 20,),
                        SizedBox(
                          height: double.infinity,
                          child:Card(
                            color: mChoice ? Colors.blue : Color(0xFFE5E5E5) ,
                            child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    mChoice = true;
                                    fChoice = false;
                                  });

                                },
                                child: Row(

                                  children: [
                                    mChoice?Icon(Icons.male,color: Colors.white,):Icon(Icons.male,color: Colors.black54,),
                                    Text('Male', style: TextStyle(color: mChoice? Colors.white : TextColor,fontWeight: FontWeight.bold, fontSize: 16)),

                                    SizedBox(width: 5,)
                                  ],)),


                          ),


                        )
                      ],

                    ),
                  ),

                ),
                (globals.medicaltData!=null &&(fChoice==false && mChoice==false))?
                Text("Required",style: TextStyle(color: Colors.red),)
                    :Text("") ,
              ],
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('Is Vaccinated?', style: TextStyle(fontWeight: FontWeight.bold, color: TextColor),),
              subtitle: Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.only(top: 10),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: double.infinity,
                            child: Card(
                              semanticContainer: true,
                              color: isVacc ? AcceptButton : Color(0xFFE5E5E5) ,
                              child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      isVacc = true;
                                      notVacc = false;
                                    });

                                  },

                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: [
                                        isVacc?
                                        Icon(
                                          Icon(Icons.check_circle,).icon,
                                          color: Colors.white,
                                        )
                                            :
                                        Container(),
                                        SizedBox(width: 5,),
                                        Text('Yes', style: TextStyle(color: isVacc? Colors.white : TextColor,fontWeight: FontWeight.bold, fontSize: 16)),
                                        SizedBox(width: 5,)
                                      ],),

                                  )

                              ),


                            )

                        ),

                        SizedBox(width: 20,),
                        SizedBox(
                            height: double.infinity,
                            child: Card(
                              semanticContainer: true,
                              color: notVacc ? AcceptButton : Color(0xFFE5E5E5) ,
                              child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      isVacc = false;
                                      notVacc = true;
                                    });

                                  },

                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: [
                                        notVacc?
                                        Icon(
                                          Icon(Icons.check_circle,).icon,
                                          color: Colors.white,
                                        )
                                            :
                                        Container(),
                                        SizedBox(width: 5,),
                                        Text('No', style: TextStyle(color: notVacc? Colors.white : TextColor,fontWeight: FontWeight.bold, fontSize: 16)),
                                        SizedBox(width: 5,)
                                      ],),

                                  )

                              ),


                            )


                        )
                      ],

                    ),
                  ),

                ),

            SizedBox(height: 10),
            ListTile(
              title: Text('Is Spayed/Neutered?', style: TextStyle(fontWeight: FontWeight.bold, color: TextColor),),
              subtitle: Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.only(top: 10),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: double.infinity,
                        child: Card(
                          semanticContainer: true,
                          color: isSet ? AcceptButton : Color(0xFFE5E5E5) ,
                          child: InkWell(
                              onTap: () async {
                                setState(() {
                                  isSet = true;
                                  notSet = false;
                                });

                              },

                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    isSet?
                                    Icon(
                                      Icon(Icons.check_circle,).icon,
                                      color: Colors.white,
                                    )
                                        :
                                    Container(),
                                    SizedBox(width: 5,),
                                    Text('Yes', style: TextStyle(color: isSet? Colors.white : TextColor,fontWeight: FontWeight.bold, fontSize: 16)),
                                    SizedBox(width: 5,)
                                  ],),

                                  )

                              ),


                            )

                        ),

                    SizedBox(width: 20,),
                    SizedBox(
                        height: double.infinity,
                        child: Card(
                          semanticContainer: true,
                          color: notSet ? AcceptButton : Color(0xFFE5E5E5) ,
                          child: InkWell(
                              onTap: () async {
                                setState(() {
                                  isSet = false;
                                  notSet = true;
                                });

                              },

                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,

                                  children: [
                                    notSet?
                                    Icon(
                                      Icon(Icons.check_circle,).icon,
                                      color: Colors.white,
                                    )
                                        :
                                    Container(),
                                    SizedBox(width: 5,),
                                    Text('No', style: TextStyle(color: notSet? Colors.white : TextColor,fontWeight: FontWeight.bold, fontSize: 16)),
                                    SizedBox(width: 5,)
                                  ],),

                              )

                          ),


                        )


                    )
                  ],

                ),
              ),

            ),
            ListTile(
              title: Text('Cat or Dog?', style: TextStyle(fontWeight: FontWeight.bold, color: TextColor),),
              subtitle: Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.only(top: 10),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: double.infinity,
                        child: Card(
                          semanticContainer: true,
                          color: isCat ? AcceptButton : Color(0xFFE5E5E5) ,
                          child: InkWell(
                              onTap: () async {
                                setState(() {
                                  isCat = true;
                                  isDog = false;
                                });

                              },

                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    isCat?
                                    Icon(
                                      Icon(Icons.check_circle,).icon,
                                      color: Colors.white,
                                    )
                                        :
                                    Container(),
                                    SizedBox(width: 5,),
                                    Text('Cat', style: TextStyle(color: isCat? Colors.white : TextColor,fontWeight: FontWeight.bold, fontSize: 16)),
                                    SizedBox(width: 5,)
                                  ],),

                              )

                          ),


                        )

                    ),

                    SizedBox(width: 20,),
                    SizedBox(
                        height: double.infinity,
                        child: Card(
                          semanticContainer: true,
                          color: isDog ? AcceptButton : Color(0xFFE5E5E5) ,
                          child: InkWell(
                              onTap: () async {
                                setState(() {
                                  isDog = true;
                                  isCat = false;
                                });

                              },

                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    isDog?
                                    Icon(
                                      Icon(Icons.check_circle,).icon,
                                      color: Colors.white,
                                    )
                                        :
                                    Container(),
                                    SizedBox(width: 5,),
                                    Text('Dog', style: TextStyle(color: isDog? Colors.white : TextColor,fontWeight: FontWeight.bold, fontSize: 16)),
                                    SizedBox(width: 5,)
                                  ],),

                                  )

                              ),


                            )


                        )
                      ],

                    ),
                  ),

                ),

            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(alignment: Alignment.topLeft,  child: Text('Medical History (optional)', style: TextStyle(fontWeight: FontWeight.bold, color: TextColor),)),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 110,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xFFF6F6F6),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.note_add,
                        size: 40,
                        color: Colors.grey,
                        semanticLabel: 'Text to announce in accessibility modes',
                      ),
                      Container(

                          child: Padding(
                            padding:  EdgeInsets.only(left:size.width*0.1,right: size.width*0.1),
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                onPressed: (){
                                  _pickFiles(1);
                                },
                                textColor: Colors.white,
                                color: AcceptButton,

                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(0,0,0,0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[

                                        Padding(
                                          padding: const EdgeInsets.only(left:8.0,right: 8),
                                          child: Container(
                                            color: AcceptButton,
                                            child: Text('Add file',
                                              style: TextStyle(color: Colors.white),),
                                          ),
                                        ),
                                        Icon(
                                          Icons.add,
                                          color:Colors.white,
                                          size: 30,
                                        ),


                                      ],
                                    ))),
                          ))
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(alignment: Alignment.topLeft,  child: Text('Vaccination (optional)', style: TextStyle(fontWeight: FontWeight.bold, color: TextColor),)),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 110,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xFFF6F6F6),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.medical_services,
                        size: 40,
                        color: Colors.grey,
                        semanticLabel: 'Text to announce in accessibility modes',
                      ),
                      Container(

                          child: Padding(
                            padding:  EdgeInsets.only(left:size.width*0.1,right: size.width*0.1),
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                onPressed: (){
                                  _pickFiles(2);
                                },
                                textColor: Colors.white,
                                color: AcceptButton,

                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(0,0,0,0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[

                                        Padding(
                                          padding: const EdgeInsets.only(left:8.0,right: 8),
                                          child: Container(
                                            color: AcceptButton,
                                            child: Text('Add Shots',
                                              style: TextStyle(color: Colors.white),),
                                          ),
                                        ),
                                        Icon(
                                          Icons.add,
                                          color:Colors.white,
                                          size: 30,
                                        ),


                                      ],
                                    ))),
                          ))
                    ],
                  ),
                ),
              ),
            ),
           // _NextButton(context),
            SizedBox(height: 20),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                    text: 'Add Pet',
                    textSize: 20,
                    textColor: Colors.white,
                    color: PrimaryButton,
                    size: Size(size.width*0.4,55),
                    pressed: () {
                      AddPet();
                    }

                ),
                CustomButton(
                    text: 'Cancel',
                    textSize: 20,
                    textColor: PrimaryButton,
                    borderColor: PrimaryButton,
                    color: PrimaryLightButton,
                    size: Size(size.width*0.3,55),
                    pressed: () {
                      Navigator.pop(context);

                    }

                )
              ],

            )


          ],
        ),

        )

    );
  }
  bool validate()
  {
    print(globals.medicaltData!.breed);

    if(globals.medicaltData==null)
      globals.medicaltData=new MedicalData();
    if(age!='')
      globals.medicaltData!.age=age;
    if(mChoice)
    {
      globals.medicaltData!.gender="male";
    }
    else if(fChoice)
    {
      globals.medicaltData!.gender="female";
    }
    if(isVacc)
    {
      globals.medicaltData!.vaccinated="true";
    }
    else if (notVacc)
    {
      globals.medicaltData!.vaccinated="false";
    }
    if(isSet)
    {
      globals.medicaltData!.stersllized="true";
    }
    else if(notSet)
    {
      globals.medicaltData!.stersllized="false";
    }
    if(isCat)
    {
      globals.medicaltData!.cat_or_dog="cat";
    }
    else if(isDog)
    {
      globals.medicaltData!.cat_or_dog="dog";
    }
    if(globals.medicaltData!.name==null ||globals.medicaltData!.name=='')
    {
      return false;
    }

    /*
    if( globals.medicaltData!.passport_ID==null ||globals.medicaltData!.passport_ID=='')
    {
      return false;
    }
    */
    if( globals.medicaltData!.breed.trim().isEmpty)
    {
      return false;
    }
    if(globals.medicaltData!.age=="")
    {
      return false;
    }
    else if(globals.medicaltData!.gender=="")
    {
      return false;
    }
    else if(globals.medicaltData!.stersllized=="")
    {
      return false;
    }
    else if(globals.medicaltData!.vaccinated=="")
    {
      return false;
    }
    else if(globals.medicaltData!.cat_or_dog=="")
    {
      return false;
    }

    else if(globals.medicaltData!.petImg == null)
    {
      return false;
    }
    return true;
  }

  showPicker(BuildContext context) {
    Picker picker = Picker(
        title: Text('Pet\'s Age'),
        adapter: PickerDataAdapter<String>(pickerdata: yList, isArray: true),
        changeToFirst: false,
        textAlign: TextAlign.left,
        textStyle: TextStyle(color: Colors.grey, fontSize: 18),
        selectedTextStyle: TextStyle(color: SubTextColor, fontSize: 18),
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          setState(() {
            age = picker.getSelectedValues().toString().replaceAll('[', '').replaceAll(']', '');
          });

        }
    );
    picker.show(_scaffoldKey.currentState!);
  }



  Widget nameField(String _label,TextEditingController controller,int id){
    return Container(
        width: double.infinity,
        height: 70,
        padding: const EdgeInsets.only(left: 20, right: 15),
        child: TextFormField(
          controller: controller,
          onChanged: (String value) {
            setState(() {
              if(globals.medicaltData==null)
                globals.medicaltData=new MedicalData();
              if(id==1)
                globals.medicaltData!.name = value;
              if(id==2)
                globals.medicaltData!.passport_ID = value;
              if(id==3)
              globals.medicaltData!.breed = value;
            });
          },
          decoration: InputDecoration(
            errorText:(globals.medicaltData!=null &&
                ((id==1 &&  globals.medicaltData!.name=='' )||(id==3 &&  globals.medicaltData!.breed=='' ))

            )?"Required":null ,
            labelText: _label,
            floatingLabelStyle: TextStyle(height: 0,fontWeight: FontWeight.bold, color: TextColor),
            filled:true,
            fillColor: Color(0xFFE5E5E5),

            focusedBorder: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: BorderSide(color: Color(0xFFE5E5E5), width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Color(0xFFE5E5E5), width: 2.0),
            ),
          ),
        ));
  }


  Widget descField(String _label,TextEditingController controller){
    return Padding(padding: EdgeInsets.all(10.0) ,
        child: TextFormField(
          minLines: 4,
          maxLines: 10,
          controller: controller,
          decoration: InputDecoration(
            errorText:(globals.medicaltData!=null &&
                (controller.text.length==0))?
            "Required"
                :null ,
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
            hintText: _label ,
          ),
        ));
  }



  void takePhoto(ImageSource source) async {
    if(globals.medicaltData==null)
    {
      globals.medicaltData=MedicalData();
    }
    var pickedFile = await _picker.pickImage(
      source: source,
    );
    setState(() {
      if(pickedFile!= null){
        globals.medicaltData!.petImg = pickedFile;
      _petPhoto = pickedFile.path;}
      Navigator.pop(context);
    });
  }
  /*void selectImages() async {
    if(globals.medicaltData==null)
    {
      globals.medicaltData=MedicalData();
      globals.medicaltData!.selectedImages=[];
    }
    final List<XFile>? selectedImages = await
    imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      //imageFileList!.addAll(selectedImages);
      for(XFile i in selectedImages){
        globals.medicaltData!.selectedImages!.add(i);
        Image img = Image.file(File(i.path));
        imageFileList!.add(img);}
    }
    print("Image List Length:" + imageFileList!.length.toString());
    setState((){});
  }*/
  late AlertDialog alert;
  void showAlertDialogWait(BuildContext context,String title) {
    alert  = AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        content: Container(
            width: 300.0,
            height: 100.0,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircularProgressIndicator(),
              Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'please Wait',
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          color: Colors.black,
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          color: Colors.black,
                        ),
                      )),
                ],
              )
            ])));

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Add Pet photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
               takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }


  AddPet()async
  {
    if(validate()) {

      showAlertDialogWait(context,"Add pet");
      MedicalData? s=globals.medicaltData;
      AuthenticationService authenticationService=new AuthenticationService();

      var result = await authenticationService.AddPetInfo(globals.medicaltData,context);
      if(result)
      {
        globals.medicaltData= MedicalData();
        showSnackbar(context, "Pet added Successfully");
        dismissWait();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  PetsListPage()),
        );
      } else {
        dismissWait();
        showSnackbar(context, "Pet not added");
      }
    }
    else
    {
      showSnackbar(context, 'Please Fill Required Info');

    }

  }
  dismissWait()
  {
    Navigator.of(context, rootNavigator: true).pop("");
  }
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _userAborted = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;

  void _pickFiles(int num) async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
      if(num==1)
        globals.medicaltData!.paths=_paths;
      else
        globals.medicaltData!.injections=_paths;
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
      _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });
  }
  void _logException(String message) {
    print(message);

  }
  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }
}



const yList = [
  ['0 Years', '1 Year','2 Years','3 Years','4 Years','5 Years',
    '6 Years', '7 Years', '8 Years','9 Years','10 Years',
    '11 Years','12 Years','13 Years','14 Years','15 Years',
    '16 Years','17 Years','18 Years','19 Years','20 Years',
    '21 Years','22 Years','23 Years', '24 Years','25 Years',
    '26 Years','27 Years','28 Years','29 Years','30 Years'],

  ['1 month', '2 months','3 months','4 months','5 months',
    '6 months', '7 months', '8 months','9 months','10 months', '11 months']
]
;