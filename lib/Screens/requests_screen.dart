import 'package:flutter/material.dart';

class ReqScreen extends StatefulWidget {
  const ReqScreen({Key? key}) : super(key: key);

  @override
  State<ReqScreen> createState() => _ReqScreen();
}

class _ReqScreen extends State<ReqScreen> {
  double sysWidth = 0.0;
  double sysHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    sysWidth = size.width;
    sysHeight = size.height;
    return Scaffold(
        body: Center(
      child:
          Text('Under Progress', style: Theme.of(context).textTheme.headline3),
    ));
  }
}
