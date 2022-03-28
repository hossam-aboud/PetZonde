import 'package:flutter/material.dart';

import 'info.dart';

class TodoGridView extends StatefulWidget {
  List<String> todoList;
  TodoGridView({Key? key, required this.todoList}) : super(key: key);

  @override
  _TodoGridViewState createState() => _TodoGridViewState();
}
class _TodoGridViewState extends State<TodoGridView> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.todoList.length,
      itemBuilder: (BuildContext context, int index) {
        return
        TodoTile(title: widget.todoList[index]
            .split(",")[1], end: widget.todoList[index].split(",")[2],
        );
        // Navigator.push(context, new MaterialPageRoute(builder: (context) => new SecondScreenWithData()));


      },
    );
  }
}