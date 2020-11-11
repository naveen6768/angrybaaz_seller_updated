import 'package:Angrybaaz_Merchands/screens/loginScreen.dart';
import 'package:flutter/material.dart';

class UnAuthoriseUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Unauthorise user!.',
              style: TextStyle(
                fontFamily: 'Lato',
                color: Colors.black54,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Navigate to login!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
