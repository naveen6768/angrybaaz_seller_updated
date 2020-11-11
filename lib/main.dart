import 'package:Angrybaaz_Merchands/screens/becomePartner.dart';
import 'package:Angrybaaz_Merchands/screens/connection_waiting.dart';
import 'package:Angrybaaz_Merchands/screens/unAuthoriseUser.dart';
import 'package:Angrybaaz_Merchands/screens/hasError.dart';
import 'package:Angrybaaz_Merchands/screens/itemOverviewScreen.dart';
import 'screens/homeOverviewScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './screens/loginScreen.dart';
import './screens/resetPassword.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final _currentUser = FirebaseAuth.instance.currentUser;
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
          if (_currentUser == null) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData.light().copyWith(
                accentColor: Color(0xff382933),
                primaryColor: Color(0xff671B97),
                scaffoldBackgroundColor: Colors.white,
                cursorColor: Color(0xff671B97),
              ),
              home: LoginScreen(),
              routes: {
                LoginScreen.id: (context) => LoginScreen(),
                ResetPassword.id: (context) => ResetPassword(),
                HomeOverviewScreen.id: (context) => HomeOverviewScreen(),
                BecomePartner.id: (context) => BecomePartner(),
                ItemOverviewScreen.id: (context) => ItemOverviewScreen(),
                // ItemAddedScreen.id: (context) => ItemAddedScreen(),
              },
            );
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light().copyWith(
              accentColor: Color(0xff382933),
              primaryColor: Color(0xff671B97),
              scaffoldBackgroundColor: Colors.white,
              cursorColor: Color(0xff671B97),
            ),
            home: _currentUser.emailVerified == false
                ? UnAuthoriseUser()
                : HomeOverviewScreen(),
            routes: {
              LoginScreen.id: (context) => LoginScreen(),
              ResetPassword.id: (context) => ResetPassword(),
              HomeOverviewScreen.id: (context) => HomeOverviewScreen(),
              BecomePartner.id: (context) => BecomePartner(),
              ItemOverviewScreen.id: (context) => ItemOverviewScreen(),
              // ItemAddedScreen.id: (context) => ItemAddedScreen(),
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
