import 'package:angrybaaz_seller/screens/becomePartner.dart';
import 'package:angrybaaz_seller/screens/homeOverview.dart';

import 'package:angrybaaz_seller/screens/resetPassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

enum AuthMode {
  Login,
  Signup,
}

class LoginScreen extends StatefulWidget {
  static const id = 'LoginScreen';
  static const InputDecoration kinputDecoration = InputDecoration(
    fillColor: Color(0xffffffff),
    filled: true,
    hintText: '',
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffd6d2c4), width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xff968c83), width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  );

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _confirmPasswordEditingController =
      TextEditingController();
  var _authmode = AuthMode.Login;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;

  String ifErrorMsg;

  Future<void> signIn(String email, String password, BuildContext ctx) async {
    try {
      user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user.emailVerified) {
        Navigator.of(context)
            .pushReplacementNamed(HomeOverviewScreen.id, arguments: email);
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.black87,
          ),
        );
      }
    } on FirebaseAuthException catch (err) {
      var messageTwo = 'password is invalid';
      if (err.message != null) {
        messageTwo = err.message;

        if (messageTwo ==
            'There is no user record corresponding to this identifier. The user may have been deleted.') {
          messageTwo = "The user doesn't exist. Please register to continue!";
        }
      }

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(messageTwo),
          backgroundColor: Colors.black87,
        ),
      );
    } catch (err) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(err),
          backgroundColor: Colors.black87,
        ),
      );
    }
  }

  Future<void> register(
      String email, String confirmPassword, BuildContext ctx) async {
    try {
      user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: confirmPassword))
          .user;

      await user.sendEmailVerification();
      print('working');
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.black87,
          ),
        );
      }
    } on FirebaseAuthException catch (err) {
      var messageTwo = 'password is invalid';
      if (err.message != null) {
        messageTwo = err.message;

        if (messageTwo ==
            'There is no user record corresponding to this identifier. The user may have been deleted.') {
          messageTwo = "The user doesn't exist. Please register to continue!";
        }
      }

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(messageTwo),
          backgroundColor: Colors.black87,
        ),
      );
    } catch (err) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(err),
          backgroundColor: Colors.black87,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget showAlert(context) {
      return AlertDialog(
        title: Text(
          'Email verification!',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Please verify the link sent to ${user.email} and then click on Proceed!',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () async {
              try {
                await _auth.currentUser.sendEmailVerification();
                await user.reload();
              } catch (e) {}
            },
            child: Text(
              'Resend!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
          FlatButton(
            child: Text(
              "Proceed",
              style: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            textColor: Colors.white,
            onPressed: () async {
              try {
                User user = await _auth.currentUser;
                await user.reload();
                user = await _auth.currentUser;

                if (user.emailVerified) {
                  return Navigator.of(context).pushNamedAndRemoveUntil(
                      BecomePartner.id, (Route<dynamic> route) => false);
                }
                if (user.emailVerified == false) {
                  return null;
                }
              } catch (e) {
                return e.message;
              }
            },
          ),
        ],
        elevation: 24.0,
        backgroundColor: Theme.of(context).primaryColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 45.0,
                  ),
                  Text(
                    _authmode == AuthMode.Login ? 'Login -' : 'Register -',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    'Email address',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      color: Color(0xff968c83),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    key: ValueKey('email'),
                    controller: _emailEditingController,
                    decoration: LoginScreen.kinputDecoration,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Password',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      color: Color(0xff968c83),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    obscureText: true,
                    controller: _passwordEditingController,
                    decoration: LoginScreen.kinputDecoration,
                    validator: (value) {
                      if (value.isEmpty || value.length < 6) {
                        return 'Password should atleast 6 characters long!';
                      }
                      return null;
                    },
                  ),
                  if (_authmode == AuthMode.Signup)
                    SizedBox(
                      height: 20.0,
                    ),
                  if (_authmode == AuthMode.Signup)
                    Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                        color: Color(0xff968c83),
                      ),
                    ),
                  if (_authmode == AuthMode.Signup)
                    SizedBox(
                      height: 10.0,
                    ),
                  if (_authmode == AuthMode.Signup)
                    TextFormField(
                      key: ValueKey('confirmemail'),
                      obscureText: true,
                      controller: _confirmPasswordEditingController,
                      decoration: LoginScreen.kinputDecoration,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (_passwordEditingController.text !=
                            _confirmPasswordEditingController.text) {
                          return 'Both passwords should match!';
                        }
                        return null;
                      },
                    ),
                  if (_authmode == AuthMode.Login)
                    SizedBox(
                      height: 7.0,
                    ),
                  if (_authmode == AuthMode.Login)
                    Row(
                      children: [
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(ResetPassword.id);
                          },
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 20.0,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () async {
                      final _isValid = _formKey.currentState.validate();
                      if (_isValid) {
                        if (_authmode == AuthMode.Login) {
                          await signIn(_emailEditingController.text,
                              _passwordEditingController.text, context);
                        }
                        if (_authmode == AuthMode.Signup) {
                          await register(_emailEditingController.text,
                              _passwordEditingController.text, context);
                          showDialog(
                            context: context,
                            builder: (ctx) => showAlert(ctx),
                            barrierDismissible: false,
                          );
                        }
                      }
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          _authmode == AuthMode.Login ? "Login" : "Register",
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (_authmode == AuthMode.Login) {
                          setState(() {
                            _authmode = AuthMode.Signup;
                          });
                        } else {
                          if (_authmode == AuthMode.Signup) {
                            setState(() {
                              _authmode = AuthMode.Login;
                            });
                          }
                        }
                      },
                      child: Chip(
                        backgroundColor: Color(0xfff3ebf7),
                        label: Text(
                          _authmode == AuthMode.Login
                              ? "Don't have an account?"
                              : "Already have an account",
                          style: TextStyle(
                              fontFamily: 'Lato',
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
