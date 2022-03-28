import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petzone/Profiles/profile_bloc.dart';
import 'package:petzone/Profiles/profile_event.dart';
import 'package:petzone/Profiles/profile_state.dart';
import 'package:petzone/Profiles/profile_view.dart';
import 'package:intl/intl.dart';
import 'package:petzone/repositories/user_repository.dart';

import '../Screens/profile/pl_settings.dart';
import '../constants.dart';



User? user = FirebaseAuth.instance.currentUser;
DocumentReference owner =
FirebaseFirestore.instance.collection('pet lovers').doc(user?.uid);
DocumentReference userRef =
FirebaseFirestore.instance.collection('users').doc(user?.uid);



class editProfileScreen extends StatelessWidget {

  final DocumentSnapshot owner;
  final UserRepository _userRepository = UserRepository();
  editProfileScreen({ Key? key, required this.owner})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Profile",
              style: TextStyle(
                color: Colors.teal[800],
              ),
            ),
            SizedBox(width: 120),
            IconButton(onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          PetLoverSettings()));
            }, icon: Icon(Icons.settings, color: Colors.teal[800],
            ))
          ],
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
      backgroundColor: Colors.white,
      body: BlocProvider<editBloc>(
        create: (context) => editBloc(userRepository: _userRepository),
        child: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 10),

                  child: editProfile(owner),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class editProfile extends StatefulWidget {

  final DocumentSnapshot owner;
  editProfile(this.owner);

  @override
  _editProfileState createState() => _editProfileState( owner:owner );
}

class _editProfileState extends State<editProfile> {
  String? _pfp;
  final ImagePicker _picker = ImagePicker();
  final UserRepository _userRepository = UserRepository();
  final DocumentSnapshot owner;
  _editProfileState({required this.owner});

  final  fnameController = TextEditingController();
  final  lnameController = TextEditingController();
  final  emailController = TextEditingController();
  final  dateOfBirthController = TextEditingController();
  final  phoneController = TextEditingController();

  String? _city ;

  DateTime selectedDate = DateTime.now();
  late editBloc _editBloc;

  @override
  void initState() {
    super.initState();
    _editBloc = BlocProvider.of<editBloc>(context);

  }

  @override
  Widget build(BuildContext context) {
    // _city = owner['city'];

    Size size = MediaQuery.of(context).size;

    return BlocListener<editBloc, ProfileState>(
      listener: (context, state) {
        if (state.isFailure!) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Text('Update Failed'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Color(0xffffae88),
              ),
            );
        }

        if (state.isSubmitting!) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Text('Updating...'),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  ],
                ),
                backgroundColor: Color(0xffffae88),
              ),
            );
        }

        if (state.isSuccess!) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Text('the information have been updating successfully '),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  ],
                ),
                backgroundColor: Color(0xffaddfad),
              ),
            );
          _userRepository.UpdatePetLover(owner, fnameController.text, lnameController.text, emailController.text,
              phoneController.text, _city.toString(), dateOfBirthController.text, _pfp);
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new ProfileView()),
          );
        }
      },
      child: BlocBuilder<editBloc, ProfileState>(
        builder: (context, state) {
          return  Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[
                secound(context),

                Padding(
                  padding: EdgeInsets.only(left: 35.0,right: 35.0,bottom: 35.0,top: 10),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      ElevatedButton(
                          onPressed:(){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                Text("your information is updated successfully "),
                                backgroundColor: Colors.green,
                              ),
                            );
                            _onFormSubmitted();
                            Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProfileView()));

                          },
                          child: Padding(
                              padding: EdgeInsets.only(left: 10.0 , right:5.0 , top: 10 , bottom: 10),
                              child: Text('Save', style: TextStyle( fontSize: 20 ))),
                          style: ElevatedButton.styleFrom(
                              primary: AcceptButton,
                              fixedSize: Size(size.width*0.35, size.height*0.06)
                          )
                      ),


                      SizedBox(width: 15),
                      ElevatedButton(
                          onPressed:(){
                            Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => ProfileView()));

                          },
                          child: Padding(
                              padding: EdgeInsets.only(left: 10.0 , right:5.0 , top: 10 , bottom: 10),
                              child: Text('Cancel', style: TextStyle( fontSize: 20 ))),
                          style: ElevatedButton.styleFrom(
                              primary: PrimaryLightButton,
                              fixedSize: Size(size.width*0.35, size.height*0.06)
                          )
                      ),



                    ],
                  ),
                )


              ]

          );
        },
      ),
    );
  }

  Widget secound(BuildContext context) {
    _pfp = owner['photoUrl'];

    return SingleChildScrollView(


        child:  Padding(
          padding: EdgeInsets.only(left: 10.0,right: 10.0),

          child: Column(


              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomSheet()),
                      );
                    },
                    child:  CircleAvatar(
                      backgroundColor: Colors.grey[400],
                      radius: 80,
                      backgroundImage:
                      _pfp != null ?
                      Image.file(File(_pfp!)).image
                          :
                      owner['photoUrl'] != null ?
                      Image.network(owner['photoUrl'].toString()).image
                          :
                      AssetImage("assets/defaultpfp.png"),


                      child: Stack(children: [
                        Align(
                            alignment: Alignment.bottomRight,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor:
                              DeclineButton.withOpacity(0.7),
                              child:
                              Icon(Icons.edit, color: Colors.white),
                            )
                        ),
                      ]),
                    )),


                SizedBox(height: 15),

                TextFields(owner,'first name',fnameController),
                TextFields(owner,'last name',lnameController),
                TextFields(owner,'email',emailController),
                dob(),
                TextFields(owner,'phone number',phoneController),
                city(),
                SizedBox(height: 15),



              ]),

        ));
  }
  Widget TextFields(DocumentSnapshot<Object?> owner , String att, TextEditingController controller){
    controller.text = owner[att];
    String label = att[0].toUpperCase() + att.substring(1);
    return  Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 20.0)  ,
        child: TextFormField(
          style: TextStyle(color: Colors.black54),
          autofocus: false,
          controller: controller,

          decoration: InputDecoration(
              labelText: label,
              filled:true,
              focusedBorder: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: BorderSide(color:  Color(0xFFF6F6F6), width: 2.0),
              ),
              hintText: att

          ),



        )
    );

  }
  Widget dob(){
    dateOfBirthController.text= owner['birth date'];

    return Container(

      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),

      child: TextFormField(

        style: TextStyle(color: Colors.black54),

        readOnly: true,
        controller: dateOfBirthController,
        decoration:  InputDecoration(
            labelText: 'Birthdate',
            filled: true,
            hintText: 'birth date',
            border: OutlineInputBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(25)),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ))),
        onTap: () async {
          var date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now());
          dateOfBirthController.text =
              DateFormat('yMMMd').format(date!);
        },
        onSaved: (Value) => dateOfBirthController.text = Value!,
        onChanged: (Val) {
          // setState(() {
          dateOfBirthController.text = Val;
          //    });
        },
      ),
    );
  }
  Widget city(){
    _city = owner['city'];
    return  Container(
        child: Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 20.0)  ,
          child:
          DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              style: const TextStyle(
                  color: Color(0xFFF6F6F6),
                  fontSize: 16
              ),dropdownColor: Color(0xFFffffff),
              focusColor: Color(0xFFF6F6F6),
              value: _city  ,
              iconEnabledColor: Colors.black54,
              items: <String>['Riyadh','Makkah','Dammam',
                'Abha','Jazan','Madinah','Buraidah','Tabuk',
                'Ha\'il','Najran','Sakaka','Al-Baha','Arar'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(

                  value:  value,

                  child: Text(
                    value,
                    style: TextStyle(color: Colors.black54) ,
                  ),
                );
              }).toList(),

              onChanged: (String? value) {
                // setState(() {
                _city = value;
                // });
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              hint: Text('city' , style: TextStyle( fontSize: 16 )),
              decoration: new InputDecoration(
                labelText: 'City',
                filled: true,
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color:Color(0xFFF6F6F6), width: 0.0),
                  borderRadius:  const BorderRadius.all(Radius.circular(25.0)),

                ),
              ),

            ),
          ),


        ));


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
            "Choose Profile photo",
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
  void takePhoto(ImageSource source) async {
    var pickedFile = await _picker.pickImage(
      source: source,
    );
    setState(() {
      _pfp = pickedFile!.path;
      Navigator.pop(context);
    });
  }


  void _onFormSubmitted() {
    _editBloc.add(PLEditSubmit(
        owner,
        FirstName:fnameController.text,
        LastName:lnameController.text,
        email:emailController.text,
        phoneNum: phoneController.text,
        city: _city.toString(),
        birthDate: dateOfBirthController.text,
        photo: _pfp ?? null
    ));
  }
}



