import 'package:flutter/material.dart';

import 'homepage/home_page.dart';

class RequestConfirm extends StatefulWidget {
  const RequestConfirm({Key? key}) : super(key: key);

  @override
  _RequestConfirmState createState() => _RequestConfirmState();
}

class _RequestConfirmState extends State<RequestConfirm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Adoption Request",
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(35, 30, 35, 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Your request has been sent and will reply to you as soon as possible",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 25),
              ),
              const SizedBox(height: 15),
              const Text("Thank you for adopting from us!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF03989E), fontSize: 30)),
              const SizedBox(height: 15),
              const Icon(
                Icons.ten_k_outlined,
                size: 100,
              ),
              const SizedBox(height: 25),
              FlatButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const homePage()),
                      (route) => false);
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
    );
  }
}
