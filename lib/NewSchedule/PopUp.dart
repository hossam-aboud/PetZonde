import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

User? user = FirebaseAuth.instance.currentUser;

DocumentReference ownerVet =
FirebaseFirestore.instance.collection('veterinarian').doc(user?.uid);

class TodoInformationPopup extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController endController;
  final String weekday;

  const TodoInformationPopup({Key? key, required this.weekday, required this.titleController, required this.endController}) : super(key: key);


  @override
  _TodoInformationPopupState createState() => _TodoInformationPopupState();
}

class _TodoInformationPopupState extends State<TodoInformationPopup> {
   TimeOfDay? _startTime ;
   TimeOfDay? _endTime ;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xff8CD3CB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 20,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            const Text("ADD TIME", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 35),),
            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: widget.titleController,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  labelText: "Start:",
                  fillColor: Colors.white,
                  filled: true,
                ),
                readOnly: true,  //set it true, so that user will not able to edit text
                onTap: () async {
                  _startTime  =  await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                  );

                  if(_startTime != null ){
                    print(_startTime?.format(context));   //output 10:51 PM
                    DateTime parsedTime = DateFormat.jm().parse(_startTime!.format(context).toString());
                    DateTime parsedTime2 = DateFormat.jm().parse(_startTime!.format(context).toString());
                    print(parsedTime); //output 1970-01-01 22:53:00.000
                    String formattedTime = DateFormat('hh:mm a').format(parsedTime);
                    String formattedTime2 = DateFormat('hh:mm a').format(parsedTime.add(Duration (minutes: 30)));


                    setState(() {
                      widget.titleController.text = formattedTime;
                      widget.endController.text = formattedTime2;
                    });

                  }else{
                    print("Time is not selected");
                  }
                },
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                controller: widget.endController,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  labelText: "End :",
                  fillColor: Colors.white,
                  filled: true,

                ),
readOnly: true,



              ),
            ),
            const SizedBox(height: 20,),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold)
              ),
              child: const Text("ADD"),
              onPressed:  () {
if(widget.titleController.toString().isNotEmpty || widget.endController.toString().isNotEmpty){

  int d = day(widget.weekday);
                addSchedule(d,widget.titleController.text ,widget.endController.text );

}

                Navigator.pop(context, false);

              } ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

   addSchedule(int day, String start, String end) async {
     var data = await FirebaseFirestore.instance
         .collection('veterinarian')
         .doc(user?.uid)
         .collection('schedule')
         .doc(widget.weekday);

      data.get().then((doc) {
       if (doc.exists) {
         data.update(
             {"data": FieldValue.arrayUnion([start +' - '+end])});
       }else{
         data.set(
             {"data": FieldValue.arrayUnion([start +' - '+end])});
       }
     });

     // print("helooooo"+exist.toString()+widget.weekday+"  "+wtf.toString());
   }


   int day (String d){
    if(d=="SUN"){
      return 7;
    }else if(d=="MON"){
      return 1;
    }else if(d=="TUE"){
      return 2;
    }else if(d=="WED"){
      return 3;
    }else if(d=="THU"){
      return 4;
    }else if(d=="FRI"){
      return 5;
    }else if(d=="SAT"){
      return 6;
    }else return 0;




   }
}
