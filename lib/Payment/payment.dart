import 'package:flutter/material.dart';
import 'package:petzone/ReqList/Request_form_Vet.dart';


class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF4E3E3),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
             ), // <-- Button color// <-- Splash color
        ),
        body: SingleChildScrollView(
            child: Center(
              child: Column(children: [
                Container(
                  padding: EdgeInsets.only(top: 280.0, left: 30, bottom: 20),
                  child: Center(
                    child: Text(
                      'your Appointment is Confirmed :),'
                          '\nsee you soon',
                      style: TextStyle(
                          color: Color(0XFF52648B),
                          fontSize: 34,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                MaterialButton(
                  minWidth: 200,
                  height: 60,
                  padding: const EdgeInsets.all(20),
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: const Text('Done'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: () async {

                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ReqVetList()))
                        .catchError((error) => print('Delete failed: $error'));
                    ;

                  },
                ),
              ]),
            )));
  }
}