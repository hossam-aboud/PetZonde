import 'package:flutter/material.dart';
import 'package:petzone/Screens/homepage/home_page.dart';

import '../../ReqList/pl_request_list_screen.dart';
import '../../constants.dart';
import '../../service/local_notifaction_service.dart';
import '../PetsListPage.dart';
import '../add_pet.dart';
import '../profile_screen.dart';
import '../requests_screen.dart';

final plGlobalKey = GlobalKey();

class petLoverScreen extends StatefulWidget {
  const petLoverScreen({Key? key}) : super(key: key);

  @override
  _petLoverScreenState createState() => _petLoverScreenState();
}

class _petLoverScreenState extends State<petLoverScreen> {
  int _selectedIndex = 0;

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];


  void changeIndex(int i) {
    setState(() {
      _selectedIndex = i;
    });
  }


  @override
  void initState() {
    super.initState();
    NotificationService.init();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
        !await _navigatorKeys[_selectedIndex].currentState!.maybePop();

        print(
            'isFirstRouteInCurrentTab: ' + isFirstRouteInCurrentTab.toString());

        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        bottomNavigationBar:
        Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: BottomNavigationBar(
                  key: plGlobalKey,
                  onTap: navigationTapped,
                  iconSize : 30.0,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  // backgroundColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.white,
                  currentIndex: _selectedIndex,
                  unselectedItemColor: Colors.grey,
                  selectedItemColor:PrimaryButton,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label:'Home'
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.pets_outlined),
                      label: 'Pets',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.assignment),
                      label: 'Requests',
                    ),
                    BottomNavigationBarItem(
                      backgroundColor: Colors.white,
                      icon: Icon(Icons.account_circle_outlined),
                      label: 'Profile',
                    ),
                  ],
                ))),
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
            _buildOffstageNavigator(3),
          ],
        ),
      ),
    );
  }



  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          new homePage(),
          PetsListPage(),
          PetLoverRequestList(),
          new ProfileScreen()
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {



    Map<String, WidgetBuilder> routeBuilders = _routeBuilders(context, index);
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {

          return MaterialPageRoute(
            builder: (context) => (routeBuilders as dynamic)[routeSettings.name](context),
          );
        },
      ),
    );
  }

  void navigationTapped(int index) {
    int  i = _selectedIndex;

    if(i==index){
      _navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
    }
    setState(() {
      _selectedIndex = index;
    }  );

  }
}