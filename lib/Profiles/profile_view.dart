import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petzone/Profiles/profile_edit_UI.dart';
import '../bloc/auth/auth_bloc.dart';
import '../constants.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart' as fb_core;

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}
DocumentReference owner =
FirebaseFirestore.instance.collection('pet lovers').doc(user!.uid);

DocumentReference userRef =
FirebaseFirestore.instance.collection('users').doc(user!.uid);
class _ProfileViewState extends State<ProfileView> {
  @override
  String getuser(){
    User? user = FirebaseAuth.instance.currentUser;
    return user!.uid.toString();
  }
  String? _pfp;
  final ImagePicker _picker = ImagePicker();
  final  fnameController = TextEditingController();
  final  lnameController = TextEditingController();
  final  emailController = TextEditingController();
  final  dateOfBirthController = TextEditingController();
  final  phoneController = TextEditingController();

  String? _city ;

  DateTime selectedDate = DateTime.now();
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                "\t Profile",
                style: TextStyle(
                  color: Colors.teal[800],
                  fontSize: 20
                ),
              ),
              SizedBox(width: 90),
              IconButton(onPressed: (){
                  BlocProvider.of<AuthBloc>(context).add(
                    SignOutRequested(),
                  );
                },
               icon: Icon(Icons.logout, color: Colors.black54, size: 30



              ))
            ],
          ),
          // leading: GestureDetector(
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          //   child: Icon(
          //     Icons.arrow_back,
          //     color: Colors.teal[800],
          //   ),
          // ),
        ),
      backgroundColor: Colors.white,
        body: Stack(

          children: [

            Center(

                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('pet lovers')
                        .where('uid', isEqualTo:  getuser().toString())
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text('loading');
                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return  Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: <Widget>[
                                  secound(context , ((snapshot.data!).docs[index])),

                                  Padding(
                                    padding: EdgeInsets.only(left: 35.0,right: 35.0,bottom: 35.0,top: 10),

                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[

                                        ElevatedButton(
                                            onPressed:() async {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content:
                                                  Text("your information is updated successfully "),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                              // _onFormSubmitted();
                                              String? url;
                                              if(_pfp != null){
                                                url =  await  uploadPfp(_pfp! ,(snapshot.data!).docs[index].toString() );
                                              }
                                              (snapshot.data!).docs[index].reference.update({
                                                'first name': fnameController.text,
                                                'last name':lnameController.text,
                                                'email':emailController.text,
                                                'photoUrl': url ?? (snapshot.data!).docs[index]['photoUrl'],
                                                'birth date':dateOfBirthController.text,
                                                'phone number':phoneController.text,
                                                'city':_city,

                                              }).catchError((error) => print("Failed to update user your information : $error"));
                                              FirebaseAuth.instance.currentUser!
                                                  .updateEmail(emailController.text)
                                                  .catchError((error) => print("Failed to update user email : $error"));

                                              userRef.update({'email':emailController.text})
                                                  .catchError((error) => print("Failed to update user email : $error"));


                                            },
                                            child: Padding(
                                                padding: EdgeInsets.only(left: 10.0 , right:5.0 , top: 10 , bottom: 10),
                                                child: Text('Save', style: TextStyle( fontSize: 20 ))),
                                            style: ElevatedButton.styleFrom(
                                                primary: AcceptButton,
                                                fixedSize: Size(size.width*0.35, size.height*0.06)
                                            )
                                        ),





                                      ],
                                    ),
                                  )


                                ]

                            );
                          }
                      );} )
            ),
            // GestureDetector(
            //   onTap: () {
            //     BlocProvider.of<AuthBloc>(context).add(
            //       SignOutRequested(),
            //     );
            //   },
            //   child: Container(
            //     padding: EdgeInsets.only(top: 40, right: 10),
            //     alignment: Alignment.topRight,
            //     child: Icon(Icons.logout, color: Colors.black54, size: 30),
            //   ),
            // ),
          ],
        )
    );
  }
  Widget secound(BuildContext context , owner) {

    return SingleChildScrollView(


        child:  Padding(
          padding: EdgeInsets.only(left: 10.0,right: 10.0 , top: 20),

          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,


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
                      radius: 70,
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
                dob(owner),
                TextFields(owner,'phone number',phoneController),
                city(owner),
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
  Widget dob(owner){
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
  Widget city(owner){
    _city = owner['city'];
    return  Container(
        child: Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 20.0)  ,
    child: DropdownButtonHideUnderline(

            child: DropdownButtonFormField<String>(
              // isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              style: const TextStyle(
                  color: Color(0xFFF6F6F6),
                  fontSize: 16
              ),
              dropdownColor: Color(0xFFffffff),
autofocus: true,
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
              autovalidateMode: AutovalidateMode.disabled,
              hint: Text('city' , style: TextStyle( fontSize: 16 )),
              decoration: new InputDecoration(
                labelText: 'City',
                filled: true,

                focusedBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: BorderSide(color:  Color(0xFFF6F6F6), width: 2.0),
                ),
                ),
              ),


            ),
          ),


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

}
Future<String> uploadPfp(String path, String uid) async{
  File file = File(path);
  String url = '';
  try {
    await FirebaseStorage.instance.ref('$uid/profile_photo').putFile(file);
    url = await FirebaseStorage.instance.ref('$uid/profile_photo').getDownloadURL();
  } on fb_core.FirebaseException catch (e) {
    print(e);
  }
  return url;
}


ButtonStyle backButton =  ElevatedButton.styleFrom(shape: CircleBorder(), padding: EdgeInsets.all(20), primary: Colors.transparent, shadowColor: Colors.transparent,);
class navKeys {
  static final globalKey = GlobalKey();
  static final globalKeyAdmin = GlobalKey();
}