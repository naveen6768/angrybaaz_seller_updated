import 'package:angrybaaz_seller/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import '../components/userProfileSectionDrawer.dart';
import '../components/drawerInkwellButton.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class HomeScreenDrawer extends StatelessWidget {
  HomeScreenDrawer(this.sellerEmail);
  final String sellerEmail;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: ListView(
          children: [
            UserProfileSectionDrawer(sellerEmail),
            Center(
              child: DrawerButtons(
                buttonTitle: 'Home Page',
                buttonIcon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ),
            ),
            DrawerButtons(
              buttonTitle: "Track Orders!",
              buttonIcon: Icon(
                Icons.assignment,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            DrawerButtons(
              buttonTitle: 'About us',
              buttonIcon: Icon(
                Icons.business_center,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            DrawerButtons(
              buttonTitle: 'Feedback',
              buttonIcon: Icon(
                Icons.feedback,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            DrawerButtons(
              buttonTitle: 'Contact us',
              buttonIcon: Icon(
                Icons.phone,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            DrawerButtons(
              buttonTitle: 'Logout',
              buttonIcon: Icon(
                Icons.backspace,
                color: Colors.white,
              ),
              onPressed: () {
                // Navigator.of(co).;
                Navigator.of(context).pushReplacementNamed(LoginScreen.id);
                // await Provider.of<Auth>(context, listen: false).authlogout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
