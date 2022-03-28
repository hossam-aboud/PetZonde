 import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petzone/Screens/homepage/home_page.dart';

import '../constants.dart';
import '../model/MedicalData.dart';
import '../model/globals.dart' as globals;
import '../service/authentication_service.dart';
import '../widgets/helper.dart';
class ProfilePet extends StatefulWidget {
  MedicalData pet;
  ProfilePet({required this.pet});

  @override
  PetsListPageState createState() => PetsListPageState();
}

class PetsListPageState extends State<ProfilePet> {
  List<Image>? imageFileList = [];
  final ImagePicker _picker = ImagePicker();
  bool isEditName=false;
  bool isEditAge=false;
  bool isEditBreed=false;
  bool isEditGender=false;
  bool isSeteralized=false;
  bool isEditMedical=false;
  bool isEditVaccination=false;
  bool fChoice=false, mChoice = false,
      isVacc = false, isSet = false,
      notVacc = false, notSet = false;
  final controller=TextEditingController();
  final nameController = TextEditingController();
  File? imgPet=null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    /* return Container(
      child: FutureBuilder(
          future: _fetchListItems(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return  Center(child: CircularProgressIndicator());
            } else {
              Container(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Text('${snapshot.data[index].name}');
                      }));
            }
          }),
    );

    */

    return


      Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body:
        SingleChildScrollView(child:
        Column(
          children: [
            PreferredSize(
              preferredSize: Size(double.infinity, 100),
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 5,
                        blurRadius: 2
                    )
                    ]
                ),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xffD0F1EB),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))
                  ),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(icon: Icon(
                          Icons.navigate_before, size: 30,
                          color: Colors.white,)
                          , onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text("Pet Profile", style: TextStyle(
                            fontSize: 18, color: Colors.white),),
                        Icon(Icons.navigate_before,
                          color: Colors.transparent,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10,),
                          GestureDetector(
                            onTap: () {
                              //selectImages(widget.pet);
                            },
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor: Color(0xffD0F1EB),
                              foregroundImage: (imgPet!=null)?FileImage(imgPet!)  : (widget.pet.imgUrl!=null )?
                              NetworkImage(widget.pet.imgUrl!): Image.asset('assets/pickimage.png').image,
                            ),
                          )
                        ]



                    ),
                    buildUserInfoDisplay(widget.pet.name, widget.pet,'Name',1,nameController,size,'pet name'),
                    buildpetsAge(widget.pet,size),
                    buildpetsBread(widget.pet,size),
                    buildpetsGender(widget.pet,size),
                    buildpetsset(widget.pet,size),
                    buildMedicalHistory(widget.pet,size),
                    buildVaccination(widget.pet,size),



                  ],
                ),
              ),
            ),

            _NextButton(context),
            SizedBox(height: 20),


          ],
        ),

        ),
      );


  }
  
 
 
 
  Widget buildVaccination(MedicalData data,Size size) {

/* ???????
    if(data.vaccination==null)
      data.vaccination='';
    controller.text=data.vaccination;
    setState(() {

    });
*/
    return
      Column(
        children: [
          ListTile(title:  Row(
            children: [
              Text(
                "Vaccination",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                )

                ,),
              SizedBox(width: 10,),


            ],
          )
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
          )
        ],
      );

  }

  Widget buildMedicalHistory(MedicalData data,Size size) {

    return
      Column(
        children: [
          ListTile(title:  Row(
            children: [
              Text(
                "Medical History",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                )

                ,),
              SizedBox(width: 10,),


            ],
          ),
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
          )
        ],
      );

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
  Widget buildUserInfoDisplay(String getValue,MedicalData data ,String title,int option ,TextEditingController controller,Size size,String hint) {
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            )

            ,),
          SizedBox(height: 10,),
          // isEdit?
          Container(
            width: size.width-10,
            child: TextFormField(
              initialValue: getValue,
              keyboardType: TextInputType.name,
              autofocus: false,
              decoration: InputDecoration(
                errorText:((data!=null && ((data.name.length==0)))
                    ||data.name.length<5)?
                "Required must be 6 characters at least"
                    :null ,
                hintText: hint,
                fillColor: Colors.grey.shade300,
                filled: true,
                contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white, width: 1.0)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white, width: 1.0)),
              ),

              onChanged: (value) {
                getValue = value;
                data.name=value;
                setState(() {

                });
              },
            ),
          )
          // :
          //Text(getValue)

        ],
      );

  }
  Widget buildpetsset(MedicalData data,Size size)
  {
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sterallized",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            )

            ,),
          SizedBox(width: 10,),
          Container(
              width: size.width-10,
              child: Sterallized(data,size)
          )


        ],
      );
  }
  Widget Sterallized(MedicalData data,Size  size)
  {
    if(data.stersllized=="true")
    {
      isVacc=true;
      notVacc=false;
    }
    else
    {
      notVacc=true;
      isVacc=false;
      notVacc=true;
    }
    setState(() {

    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(

          height: 60,
          padding: const EdgeInsets.only(top: 10),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height:60,
                  child: Card(
                    semanticContainer: true,
                    color: isVacc ? AcceptButton : Color(0xFFE5E5E5) ,
                    child: InkWell(
                        onTap: () async {
                          setState(() {
                            isVacc = true;
                            notVacc = false;
                            data.stersllized="true";
                          });

                        },

                        child: Padding(
                          padding: EdgeInsets.all(1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              isVacc?
                              Icon(
                                Icon(Icons.check_circle,).icon,
                                color: Colors.white,
                              )
                                  :
                              Container(),
                              SizedBox(width: 1,),
                              Text('Yes', style: TextStyle(color: isVacc? Colors.white : TextColor,fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(width: 1,)
                            ],),

                        )

                    ),


                  )

              ),

              SizedBox(width: 1,),
              SizedBox(
                  height: 60,
                  child: Card(
                    semanticContainer: true,
                    color: notVacc ? AcceptButton : Color(0xFFE5E5E5) ,
                    child: InkWell(
                        onTap: () async {
                          setState(() {
                            isVacc = false;
                            notVacc = true;
                            data.stersllized="false";
                          });

                        },

                        child: Padding(
                          padding: EdgeInsets.all(1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              notVacc?
                              Icon(
                                Icon(Icons.check_circle,).icon,
                                color: Colors.white,
                              )
                                  :
                              Container(),
                              SizedBox(width: 1,),
                              Text('No', style: TextStyle(color: notVacc? Colors.white : TextColor,fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(width: 1,)
                            ],),

                        )

                    ),


                  )


              )
            ],

          ),
        )
      ],

    );
  }

  Widget buildpetsGender(MedicalData data,Size size)
  {
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gender",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            )

            ,),
          SizedBox(width: 10,),
          Container(
              width: size.width-10,
              child: Gender(data)
          )
        ],
      );
  }
  Widget Gender(MedicalData data)
  {
    if(data.gender=="male")
      mChoice=true;
    else
      fChoice=true;
    isSet=true;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
            height: 50,
            child: Card(
              semanticContainer: true,
              color: fChoice ? Color(0xFFFF71AF) : FieldColor ,
              child: InkWell(
                onTap: () async {
                  setState(() {
                    fChoice = true;
                    mChoice = false;
                    data.gender="female";
                  });

                },

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    fChoice?Icon(Icons.female,color: Colors.white,):Icon(Icons.female,color: Colors.black54,),
                    Text('Female', style: TextStyle(color: fChoice? Colors.white : TextColor,fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(width: 5,)
                  ],),

              ),


            )

        ),


        SizedBox(
          height: 50,
          child:Card(
            color: mChoice ? Colors.blue : Color(0xFFE5E5E5) ,
            child: InkWell(
                onTap: () async {
                  setState(() {
                    mChoice = true;
                    fChoice = false;
                    data.gender="male";
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

    );
  }
  Widget buildpetsBread(MedicalData data,Size size)
  {
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Breed",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            )

            ,),
          SizedBox(width: 10,),
          Container(
            width: size.width-10,
            child: TextFormField(
              initialValue: (data.breed!=null)?data.breed:"",
              keyboardType: TextInputType.name,
              autofocus: false,
              decoration: InputDecoration(
                hintText: "Breed",
                fillColor: Colors.grey.shade300,
                filled: true,
                contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white, width: 1.0)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white, width: 1.0)),
              ),

              onChanged: (value) {
                data.breed=value;
              },
            ),
          ),
          (data!=null && ((data.breed.length==0)))?
          Text('Required',style: TextStyle(color: Colors.red),)
              :Text('') ,
        ],
      );
  }
  var items = ['Riyadh','Makkah','Dammam','Abha','Jazan','Madinah','Buraidah','Tabuk','Ha\'il','Najran','Sakaka','Al-Baha','Arar'];
  late String dropdownvalue =items[0];
  Widget CityDropDown(MedicalData data){
    dropdownvalue=data.breed;
    setState(() {

    });
    return Container(
        width: double.infinity,
        height: 50,
        // padding: const EdgeInsets.only(left: 20, right: 15),

        child: DropdownButtonFormField(
            decoration: InputDecoration(
              filled: true,
              fillColor: FieldColor,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryButton),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AcceptButton),
              ),
            ),
            // Initial Value
            value: items[0],

            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down),
            style: new TextStyle(
              color: SubTextColor,
              fontSize: 18,
            ),

            // Array list of items
            items: items.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownvalue = newValue!;
                data.breed=newValue;
              });
            }
        ));
  }
  Widget buildpetsAge(MedicalData data,Size size)
  {
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Age",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            )

            ,),
          SizedBox(height: 10,),

          Container(
            width: size.width,
            child: GestureDetector(
              child:  Container(
                  width:  size.width,
                  height: 50,
                  padding: const EdgeInsets.only(top:15),
                  decoration: BoxDecoration(
                    color: FieldColor,
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: PrimaryButton),

                    ),
                  ),
                  child: Text(data.age.isEmpty ? 'Pet\'s Age' : data.age,
                    style: TextStyle(fontSize: 18, color: SubTextColor),
                  )
              ),
              onTap: () {
                showPicker(context,data);
              },
            ),
          ),
          (data!=null && ((data.age.length==0)))?
          Text('Required',style: TextStyle(color: Colors.red),)
              :Text('') ,

        ],
      );
  }
  showPicker(BuildContext context,MedicalData data) {
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
            data.age = picker.getSelectedValues().toString().replaceAll('[', '').replaceAll(']', '');
          });

        }
    );
    picker.show(_scaffoldKey.currentState!);
  }
  var yList = [
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
  Widget _NextButton(BuildContext context){
    return ElevatedButton(
      onPressed:(){
        UpdatePet();
      },
      child: Padding(
          padding: EdgeInsets.only(left: 25.0 , right:25.0 , top: 10 , bottom: 10),
          child: Text('save',  style: TextStyle( fontSize: 20 ))),
      style: ButtonStyle(
        backgroundColor:  MaterialStateProperty.all<Color>(PrimaryButton),
      ) ,
    );}

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
  UpdatePet()async
  {
    if(validate()) {
      showAlertDialogWait(context, "Update pet's profile");
      MedicalData? s = globals.medicaltData;
      AuthenticationService authenticationService = new AuthenticationService();

      var result = await authenticationService.UpdatePetInfo(
          widget.pet, context);
      if (result) {
        showSnackbar(context, "Pet updated Successfully");
        dismissWait();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => homePage()),
        );
      } else {
        dismissWait();
        showSnackbar(context, "Pet not added");
      }
    }
    else
    {
      showSnackbar(context, 'Please Fill Required Info');
      setState(() {

      });
    }
  }
  bool validate()
  {
    if(widget.pet!.breed=="")
    {
      return false;
    }
    if(widget.pet!.name.length<5||widget.pet.name.length==0)
      return false;
    return true;
  }

  dismissWait()
  {
    Navigator.of(context, rootNavigator: true).pop("");
  }
}

