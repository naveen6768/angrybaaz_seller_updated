import 'package:angrybaaz_seller/screens/becomePartner.dart';
import 'package:angrybaaz_seller/screens/connection_waiting.dart';
import 'package:angrybaaz_seller/screens/hasError.dart';
import 'package:angrybaaz_seller/screens/homeOverviewScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './screens/loginScreen.dart';

import './screens/resetPassword.dart';
// import './screens/createPassword.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return HasError();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light().copyWith(
              accentColor: Color(0xff382933),
              primaryColor: Color(0xff671B97),
              scaffoldBackgroundColor: Colors.white,
              cursorColor: Color(0xff671B97),
              // textTheme: TextTheme(
              //   bodyText1: TextStyle(
              //     fontFamily: 'Montserrat',
              //   ),
              // ),
            ),
            initialRoute: BecomePartner.id,
            routes: {
              LoginScreen.id: (context) => LoginScreen(),
              ResetPassword.id: (context) => ResetPassword(),

              // CreatePassword.id: (context) => CreatePassword(),
              HomeOverviewScreen.id: (context) => HomeOverviewScreen(),
              BecomePartner.id: (context) => BecomePartner(),
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return ConnectionWaiting(
          ctx: context,
        );
      },
    );
  }
}
