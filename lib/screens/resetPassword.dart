import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPassword extends StatefulWidget {
  static const id = 'ResetPassword';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _resetPasswordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _snackBarToggler = true;

  Future<void> resetPassword(String email) async {
    try {
      var user = await _auth.sendPasswordResetEmail(email: email);
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        setState(() {
          _snackBarToggler = false;
        });
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
        setState(() {
          _snackBarToggler = false;
        });
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
      setState(() {
        _snackBarToggler = false;
      });
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
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black87,
                          size: 27.0,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Lato',
                          fontSize: 18.0,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.question_answer)
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Reset Password',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Lato'),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "Enter the email associated with your account and we'll send an email with instructions to reset your password.",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Lato'),
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
                    decoration: LoginScreen.kinputDecoration,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    controller: _resetPasswordController,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () async {
                      final _isValid = _formKey.currentState.validate();
                      FocusScope.of(context).unfocus();
                      if (_isValid) {
                        var user =
                            await resetPassword(_resetPasswordController.text);

                        if (_snackBarToggler) {
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Please, Check your inbox!"),
                              duration: Duration(seconds: 10),
                              backgroundColor: Colors.black87,
                              action: SnackBarAction(
                                textColor: Colors.lightBlueAccent,
                                label: 'Continue Login!',
                                onPressed: () {
                                  Navigator.pushNamed(context, LoginScreen.id);
                                },
                              ),
                            ),
                          );
                        }
                      }
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
                          'Send Instructions',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
