import 'package:flutter/material.dart';
import 'package:petzone/Screens/homepage/home_page.dart';

import '../adoption_request/org_request_screen.dart';

class DecisionResult extends StatefulWidget {
  const DecisionResult({Key? key, required this.wasAccept}) : super(key: key);
  final bool wasAccept;

  @override
  _DecisionResult createState() => _DecisionResult();
}

class _DecisionResult extends State<DecisionResult> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Request Updated",
              style: TextStyle(
                color: Colors.teal[800],
              ),
            ),
            leading: GestureDetector(
              child: Icon(
                Icons.arrow_back,
                color: Colors.teal[800],
              ),
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(35, 30, 35, 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/dog.png",
                    height: 150,
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    "The request status has been updated successfully.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 25),
                  ),
                  const SizedBox(height: 50),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => orgRequestScreen()),
                      );
                    },
                    color: Color(0xFFF88A8A),
                    minWidth: 150,
                    height: 50,
                    child: const Text("OK",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const homePage()),
              (route) => false);
          return true;
        });
  }
}
