import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';



class PetLoverSettings extends StatefulWidget {

  @override
  _PetLoverSettings createState() => _PetLoverSettings();
}

class _PetLoverSettings extends State<PetLoverSettings> {
bool petSitterValue = false;
  @override
  initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Profile Settings",
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
        body:  Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                Icon(Icons.person),
                SizedBox(width: 20),
                Text('Account', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
                ]),
                Divider(height: 20, thickness: 1),
                SizedBox(height: 10),
               Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pet Sitter', style: TextStyle(fontSize: 20, color: TextColor)),
                CupertinoSwitch(
                    value: petSitterValue,
                    onChanged: (bool newValue){
                      setState(() {
                        petSitterValue = newValue;
                      });
                    })
                //Icon(Icons.arrow_forward_ios, color: Colors.grey)
              ],
            ),
          ),
               Divider(indent: 10),
               GestureDetector(
                 onTap: () {},
                 child: Padding(
                   padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('Change Password', style: TextStyle(fontSize: 20, color: TextColor)),
                       //Icon(Icons.arrow_forward_ios, color: Colors.grey)
                     ],
                   ),
                 ),
               ),
              Divider(indent: 10),
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.blueGrey),
                      SizedBox(width: 10),
                      Text('Log Out', style: TextStyle(fontSize: 20, color: TextColor)),
                      //Icon(Icons.arrow_forward_ios, color: Colors.grey)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              Divider(indent: 10),
              GestureDetector(
                 onTap: () {},
                 child: Padding(
                   padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                   child: Row(
                     children: [
                       Icon(Icons.delete, color: Colors.red),
                       SizedBox(width: 10),
                       Text('Delete Account', style: TextStyle(fontSize: 20, color: Colors.red)),
                     ],
                   ),
                 ),

               ),

            ],

          ),
          
        )
    );
  }
}