import 'package:flutter/material.dart';

import 'ListDays.dart';
import 'PopUp.dart';
import 'grid.dart';

class ScheduleUI extends StatefulWidget {
  const ScheduleUI({Key? key}) : super(key: key);

  @override
  _ScheduleUIState createState() => _ScheduleUIState();
}

class _ScheduleUIState extends State<ScheduleUI> {


  TextEditingController titleController = TextEditingController();
  TextEditingController endController = TextEditingController();


  List<String> dayDependentTodos = [];

  List<String> todoInformation = [

  ];

  String weekday = "";

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.redAccent),
            )
        )
    );
  }

  void changeWeekday(String newDay) {
    setState(() {
      weekday = newDay;
    });
    print("changed, $weekday");

    updateList();
  }

  void updateList() {
    dayDependentTodos.clear();
    for (int i = 0; i < todoInformation.length; i++) {
      if (todoInformation[i].split(",")[0] == weekday) {
        dayDependentTodos.add(todoInformation[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff8CD3CB),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff8CD3CB),
        elevation: 0.0,
        title: const Text("Weekly Schedule"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20,),
          HorizontalDayList(dayUpdateFunction: changeWeekday,),
          const SizedBox(height: 20,),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  boxShadow: [BoxShadow(blurRadius: 10.0)]
              ),
              child: TodoGridView(todoList: dayDependentTodos,),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return TodoInformationPopup( weekday: weekday , titleController: titleController , endController: endController,);
              }
          ).then((value) {
            setState(() {
              if ( titleController.text == "" || endController.text == "") {
                showInSnackBar("You Must Add Time");
              } else {
                todoInformation.add("$weekday,${titleController.text},${endController.text}");
                updateList();
                titleController.clear();
                endController.clear();
              }
            });
          });
        },
        splashColor: Color(0xff8CD3CB),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        backgroundColor: Color(0xff8CD3CB),
        child: const Icon(Icons.add, size: 50,),
      ),
    );
  }
}