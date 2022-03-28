import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/Screens/adoption_request/adopt_request_list.dart';
import 'package:petzone/bloc/handover_list/org_handover_list_bloc.dart';
import 'package:petzone/widgets/profile.dart';

import '../handovering/org_handover_request_list.dart';


class orgRequestScreen extends StatefulWidget {

  @override
  _orgRequestScreenState createState() => _orgRequestScreenState();
}

class _orgRequestScreenState extends State<orgRequestScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Requests",
            style: TextStyle(
              color: Colors.teal[800],
            ),
          ),
        ),
        body: CustomTabBar(
          tabs: [Tab(text: 'Adoption'), Tab(text: 'Handovering')],
          tabView: [
            orgAdoptionRequest(),
            BlocProvider(
              create: (context) => HandoverListBloc()..add(LoadRequestsEvent()),
              child: orgHandoverRequest(),
            )
          ],)


    );
  }
}