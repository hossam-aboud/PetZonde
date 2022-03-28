import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/Screens/homepage/pet_lover_homepage.dart';
import 'package:petzone/Screens/homepage/vet_homepage.dart';
import 'package:petzone/bloc/auth/auth_bloc.dart';

import '../log_in.dart';
import 'admin_homepage.dart';
import 'organization_homepage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/foundation.dart';

Future<void> saveTokenToDatabase(String token) async {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  await FirebaseFirestore.instance.collection('users').doc(userId).update({
    'tokens': FieldValue.arrayUnion([token]),
  });
}

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);
  @override
  _homePage createState() => _homePage();
}

class _homePage extends State<homePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void initilizeToken() async {
    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database
    await saveTokenToDatabase(token!);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
    print("TOKENNN:" + token);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(listener: (context, state) {
      if (state is UnAuthenticated) {
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => new LoginScreen()));
      }
    }, child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is Authenticated) {
        initilizeToken();
        return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                /*GestureDetector(
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
                ),*/
                homepage(state.role)
              ],
            ));
      }
      return Text("not logged in");
    }));
  }

  Widget homepage(String role) {
    if (role == "Admin") {
      return adminHomepage();
    } else if (role == "Pet Lover") {
      return petLoverHomepage();
    } else if (role == "adoption organization") {
      return orgHomepage();
    } else if (role == "veterinarian") {
      return vetHomepage();
    }
    return Text("not logged in");
  }
}
