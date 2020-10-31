import 'package:angrybaaz_seller/screens/addedItemsStore.dart';
import 'package:angrybaaz_seller/screens/homeOverviewScreen.dart';
import 'package:angrybaaz_seller/screens/receivedOrdered.dart';
import 'package:angrybaaz_seller/screens/updateProfile.dart';
import 'package:flutter/material.dart';

class NavigationBarBottom extends StatefulWidget {
  @override
  _NavigationBarBottomState createState() => _NavigationBarBottomState();
}

class _NavigationBarBottomState extends State<NavigationBarBottom> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
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
          icon: Icon(Icons.assignment),
          label: "Menu's",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        print(index);
        if (index == 0) {
          setState(() {
            return HomeOverviewScreen();
          });
        }
        if (index == 1) {
          return AddedProductsStore();
        }
        if (index == 2) {
          return ReceivedOrder();
        }
        if (index == 3) {
          return UpdateProfile();
        }
      },
    );
  }
}
