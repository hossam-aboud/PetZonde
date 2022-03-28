import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/Profiles/profile_bloc.dart';
import 'package:petzone/Profiles/profile_event.dart';
import 'package:petzone/Profiles/profile_state.dart';
import 'package:petzone/Profiles/profile_view.dart';
import 'package:petzone/Profiles/profile_view_org.dart';
import 'package:petzone/repositories/user_repository.dart';

import '../constants.dart';



User? user = FirebaseAuth.instance.currentUser;
DocumentReference ownerOrg =
FirebaseFirestore.instance.collection('adoption organization').doc(user?.uid);
DocumentReference userRef =
FirebaseFirestore.instance.collection('users').doc(user?.uid);



class editProfileScreenOrg extends StatelessWidget {
  final DocumentSnapshot ownerOrg;
  final UserRepository _userRepository = UserRepository();
  editProfileScreenOrg({ Key? key, required this.ownerOrg})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Edit Profile",
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
      backgroundColor: Colors.white,
      body: BlocProvider<editBlocOrg>(
        create: (context) => editBlocOrg(userRepository: _userRepository),
        child: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 10),

              child: editProfileOrg(ownerOrg),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class editProfileOrg extends StatefulWidget {
  final DocumentSnapshot ownerOrg;
  editProfileOrg(this.ownerOrg);

  @override
  _editProfileState createState() => _editProfileState( ownerOrg:ownerOrg);
}

class _editProfileState extends State<editProfileOrg> {
  final UserRepository _userRepository = UserRepository();
  final DocumentSnapshot ownerOrg;
  _editProfileState({required this.ownerOrg});

final  nameController = TextEditingController();
  final  emailController = TextEditingController();
  final  phoneController = TextEditingController();
  String? _city ;
  final desController = TextEditingController();


  DateTime selectedDate = DateTime.now();
  late editBlocOrg _editBlocOrg;

  @override
  void initState() {
    super.initState();
    _editBlocOrg = BlocProvider.of<editBlocOrg>(context);

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<editBlocOrg, ProfileState>(
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
          _userRepository.UpdateOrg(ownerOrg, nameController.text,  emailController.text, phoneController.text, _city.toString(), desController.text);
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new ProfileViewOrg()),
          );
        }
      },
      child: BlocBuilder<editBlocOrg, ProfileState>(
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

                          _onFormSubmitted();
                        Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => ProfileViewOrg()));

                      },

                      child: Padding(
                          padding: EdgeInsets.only(left: 34.0 , right:34.0 , top: 10 , bottom: 10),
                          child: Text('Save', style: TextStyle( fontSize: 20 ))),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(AcceptButton),
                      ) ,
                    ),
                    SizedBox(width: 15),
                    ElevatedButton(
                      onPressed:(){
                        Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => ProfileViewOrg()));

                      },
                      child: Padding(
                          padding: EdgeInsets.only(left: 25.0 , right:25.0 , top: 10 , bottom: 10),
                          child: Text('Cancel', style: TextStyle( fontSize: 20 ))),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(DeclineButton),
                      ) ,
                    ),



                  ],
                ),
          )]);
        },
      ),
    );
  }

  Widget secound(BuildContext context) {

    return SingleChildScrollView(


                child:  Padding(
        padding: EdgeInsets.only(left: 10.0,right: 10.0),

    child: Column(


                    children: <Widget>[

                      CircleAvatar(
                        backgroundColor: Colors.grey[400],
                        radius: 80,
                          backgroundImage: ownerOrg['photoUrl'] != null ?
                          Image.network(ownerOrg['photoUrl'].toString()).image
                              :
                          AssetImage("assets/defaultpfp.png")
                      ),

                      SizedBox(height: 15),

                      TextFields(ownerOrg,'name',nameController),
                      TextFields(ownerOrg,'email',emailController),
                      TextFields(ownerOrg,'phone',phoneController),
                      city(),
                      TextFields(ownerOrg,'description',desController),

                      SizedBox(height: 15),



                    ]),

              ));
  }
  Widget TextFields(DocumentSnapshot<Object?> owner , String att, TextEditingController controller){
    controller.text = owner[att];
    String label = att[0].toUpperCase() + att.substring(1);

    return  Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 20.0)  ,
        child: TextFormField(
          maxLines: att =='description' ? 5 : 1,
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

Widget city(){
    _city = ownerOrg['city'];
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


  void _onFormSubmitted() {
    _editBlocOrg.add(OrgEditSubmit(
      ownerOrg,
      Name:nameController.text,
      email:emailController.text,
      phoneNum: phoneController.text,
      city: _city.toString(),
      description: desController.text,

    ));
  }

}





