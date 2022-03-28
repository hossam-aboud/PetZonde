import 'package:flutter/material.dart';
import 'package:flutter_bloc/src/bloc_provider.dart';
import 'package:petzone/bloc/lost_and_found/lost_and_found_list_bloc.dart';

import '../constants.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    Key? key,
    required this.tabs,
    required this.tabView,
  }) : super(key: key);

  final List<Tab> tabs;
  final List<Widget> tabView;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabs.length, // length of tabs
        initialIndex: 0,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
          Container(
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: PrimaryButton,
              labelColor: DeclineButton,
              unselectedLabelColor: TextColor,
              labelStyle: TextStyle(fontSize: 16),
              tabs: tabs,
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height*0.73, //height of TabBarView
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
              ),
              child: TabBarView(children: tabView)
          )
        ])
    );
  }
}