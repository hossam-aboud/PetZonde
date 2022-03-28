import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/Profiles/profile_edit_UI_Org.dart';
import '../bloc/auth/auth_bloc.dart';
import '../constants.dart';

User? user = FirebaseAuth.instance.currentUser;
class ProfileViewOrg extends StatefulWidget {
  const ProfileViewOrg({Key? key}) : super(key: key);
  @override
  _ProfileViewOrgState createState() => _ProfileViewOrgState();
}

DocumentReference ownerOrg =
FirebaseFirestore.instance.collection('adoption organization').doc(user!.uid);

DocumentReference userRef =
FirebaseFirestore.instance.collection('users').doc(user!.uid);

class _ProfileViewOrgState extends State<ProfileViewOrg> {
  @override
  String getuser(){
    User? user = FirebaseAuth.instance.currentUser;
    return user!.uid.toString();
  }

  final  nameController = TextEditingController();
  final  emailController = TextEditingController();
  final  phoneController = TextEditingController();
  String? _city ;
  final desController = TextEditingController();


  DateTime selectedDate = DateTime.now();
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
//         appBar: AppBar(
//             title: const Text('Profile', style: TextStyle( color: Color(0xff656F77),fontSize: 30),),
//             backgroundColor: Colors.black,
//             bottomOpacity: 0.0,
//           elevation: 0.0,
//           // iconTheme: IconThemeData(color: Color(0xff656F77),),
// toolbarHeight: 70,
//         ),
        body: Stack(
          children: [
            Center(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('adoption organization')
                        .where('uid', isEqualTo:  getuser().toString())
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text('loading');
                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return
                              Padding(
                                padding: EdgeInsets.only(left: 0.0,right: 0.0,bottom: 35.0,top: 10),
                                child: Column(
                                  children: [
                                    secound(context , ((snapshot.data!).docs[index])),

                                  SizedBox(height: 15),
                                    Center(

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


                                              (snapshot.data!).docs[index].reference.update({
                                                'name': nameController.text,
                                                'email':emailController.text,
                                                'description':desController.text,
                                                'phone':phoneController.text,
                                                'city':_city,

                                              }).catchError((error) => print("Failed to update user your information : $error"));
                                              FirebaseAuth.instance.currentUser!
                                                  .updateEmail(emailController.text)
                                                  .catchError((error) => print("Failed to update user email : $error"));


                                              userRef.update({'email':emailController.text})
                                                  .catchError((error) => print("Failed to update user email : $error"));

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
                                              emailController.text= (snapshot.data!).docs[index]['email'];
                                              nameController.text= (snapshot.data!).docs[index]['name'];
                                              desController.text= (snapshot.data!).docs[index]['description'];
                                              phoneController.text= (snapshot.data!).docs[index]['phone'];
                                              _city= (snapshot.data!).docs[index]['city'];

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

                                    )
                                  ],
                                ),
                              ) ;
                          }
                      );} )
            ),
            GestureDetector(
              onTap: () {
                BlocProvider.of<AuthBloc>(context).add(
                  SignOutRequested(),
                );
              },
              child: Container(
                padding: EdgeInsets.only(top: 40, right: 10),
                alignment: Alignment.topRight,
                child: Icon(Icons.logout, color: Colors.black54, size: 30),
              ),
            ),
          ],
        )
    );
  }
  Widget secound(BuildContext context , ownerOrg ) {

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
                city(ownerOrg),
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
  Widget city(ownerOrg){
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
}