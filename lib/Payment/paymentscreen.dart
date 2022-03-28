import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Payment.dart';


class Paymentscreen extends StatefulWidget{


  @override
  _Paymentscreen createState()=>_Paymentscreen();
}
class _Paymentscreen extends State<Paymentscreen>{
  String img ="";
  double? price = 10;
  void initState() {
    super.initState();
  }
  String _loadHTML(){
    return 'http://192.168.100.23:8000/price?id=$price';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(20),
              primary: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
          ), // <-- Button color// <-- Splash color
        ),
        backgroundColor:  Colors.white24,

        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    'Payment',
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 34,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                ),
                SizedBox(height: 20),

                Container(
                    constraints: BoxConstraints(
                      maxHeight: 550,
                      maxWidth: 350,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color(0xffffffff)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child:
                        WebView(
                          onPageStarted:(url) {
                            if (url.contains('/success')) {
                              print(url);
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => Payment()));
                            }
                            if (url.contains('/cancel')) {
                              Navigator.of(context).pop();
                            }
                          },
                          onPageFinished:(url){
                            if(url.contains('/success')){
                              print(url);



                              Navigator.push(context, MaterialPageRoute(builder: (context)=> Payment()));
                            }
                            if(url.contains('/cancel')) {
                              Navigator.of(context).pop();
                            }
                          },

                          javascriptMode: JavascriptMode.unrestricted,
                          initialUrl: _loadHTML(),
                        )
                    ))] ),


        )

    );
  }
}

