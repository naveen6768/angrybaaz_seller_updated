import 'package:Angrybaaz_Merchands/screens/addedItemsStore.dart';
import 'package:Angrybaaz_Merchands/screens/homeOverviews.dart';
import 'package:Angrybaaz_Merchands/screens/receivedOrdered.dart';
import 'package:Angrybaaz_Merchands/screens/updateProfile.dart';
import 'package:Angrybaaz_Merchands/widgets/homeScreenDrawer.dart';

import 'package:flutter/material.dart';

class HomeOverviewScreen extends StatefulWidget {
  static const id = 'HomeOverviewScreen';
  static const kdecoration = InputDecoration(
    fillColor: Color(0xffF0F0F0),
    filled: true,
    hintText: '',
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white30, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black45, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  );

  @override
  _HomeOverviewScreenState createState() => _HomeOverviewScreenState();
}

class _HomeOverviewScreenState extends State<HomeOverviewScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    HomeOverview(),
    AddedProductsStore(),
    ReceivedOrder(),
    UpdateProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: HomeScreenDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('create_store!'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black,
        elevation: 8.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: "Store",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delivery_dining),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
