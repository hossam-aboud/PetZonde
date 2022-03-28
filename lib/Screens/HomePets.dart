import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

class HomePets extends StatefulWidget {
  HomePets({Key? key}) : super(key: key);

  @override
  PetsListPageState createState() => PetsListPageState();
}

class PetsListPageState extends State<HomePets> {
  @override
  Widget build(BuildContext context) {
    /* return Container(
      child: FutureBuilder(
          future: _fetchListItems(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return  Center(child: CircularProgressIndicator());
            } else {
              Container(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Text('${snapshot.data[index].name}');
                      }));
            }
          }),
    );

    */

    return Center(
        child: Container(
            child: Column(
                children: [
                  Container(
                    color: Color(0xffD0F1EB),
                    width: MediaQuery.of(context).size.width,
                    height:  100,
                    alignment: Alignment.center,
                    child:Padding(
                      padding: const EdgeInsets.only(top:30),
                      child: Container(
                        child: Text(
                          "Home",
                          style: TextStyle(color: Colors.white, fontSize: 18.0),

                        ),
                      ),
                    ),
                  ),

                ]))
    );


  }

}