import 'dart:async';
import 'package:angrybaaz_seller/screens/homeOverviewScreen.dart';
import 'package:angrybaaz_seller/screens/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:lottie/lottie.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class BecomePartner extends StatefulWidget {
  static const id = 'BecomePartner';

  @override
  _BecomePartnerState createState() => _BecomePartnerState();
}

class _BecomePartnerState extends State<BecomePartner> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _saving = false;
  double sellerLattitude;
  double sellerLongitude;
  String shopLocality = '';
  String shopPostalCode = '';
  String shopAddress = '';
  bool _locationToggler = false;
  final FirebaseFirestore _storeData = FirebaseFirestore.instance;

  final TextEditingController _sellerNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _gstNumberController = TextEditingController();
  final TextEditingController _shopAddressController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();

  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      sellerLattitude = position.latitude;
      sellerLongitude = position.longitude;
      final coordinates = new Coordinates(sellerLattitude, sellerLongitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      shopLocality = addresses.first.locality;
      shopAddress = addresses.first.addressLine;
      shopPostalCode = addresses.first.postalCode;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image(
                        height: 130.0,
                        image: NetworkImage(
                            'https://firebasestorage.googleapis.com/v0/b/thelaaz-c9197.appspot.com/o/admin_app_marketing%2Fvector_images%2Fdeal.png?alt=media&token=60303777-0918-4e07-9d64-1f121080a2a6'),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Center(
                      child: Text(
                        'Partner with us!',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      'Seller Name',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                        fontSize: 17.0,
                        color: Color(0xff968c83),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      controller: _sellerNameController,
                      key: ValueKey('sellername'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 2) {
                          return 'enter a valid name!';
                        }
                        return null;
                      },
                      decoration: LoginScreen.kinputDecoration,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Mobile number',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                        fontSize: 17.0,
                        color: Color(0xff968c83),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      controller: _mobileNumberController,
                      key: ValueKey('mobilenumber'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 10) {
                          return 'enter a valid mobile number!';
                        }
                        return null;
                      },
                      decoration: LoginScreen.kinputDecoration,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Shop name',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                        fontSize: 17.0,
                        color: Color(
                          0xff968c83,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      controller: _shopNameController,
                      key: ValueKey('shopname'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 2) {
                          return 'enter a valid name!';
                        }
                        return null;
                      },
                      decoration: LoginScreen.kinputDecoration,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Gst number',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                        fontSize: 17.0,
                        color: Color(
                          0xff968c83,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      controller: _gstNumberController,
                      key: ValueKey('gstnumber'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 15) {
                          return 'enter a valid gst number!';
                        }
                        return null;
                      },
                      decoration: LoginScreen.kinputDecoration,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Card(
                      elevation: 5.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff463333),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: !_locationToggler
                              ? const EdgeInsets.fromLTRB(14.0, 5.0, 14.0, 20.0)
                              : const EdgeInsets.fromLTRB(
                                  14.0, 10.0, 14.0, 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Use current location for shop address?',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Spacer(),
                                  Switch(
                                    value: _locationToggler,
                                    onChanged: (value) {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        _locationToggler = value;
                                      });
                                      if (_locationToggler == true) {
                                        getLocation();
                                      }
                                    },
                                    activeTrackColor: Colors.lightGreenAccent,
                                    activeColor: Colors.green,
                                  ),
                                ],
                              ),
                              if (!_locationToggler)
                                SizedBox(
                                  height: 18.0,
                                ),
                              if (!_locationToggler)
                                Text(
                                  'Enter shop address',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17.0,
                                    color: Colors.white,
                                  ),
                                ),
                              if (!_locationToggler)
                                SizedBox(
                                  height: 8.0,
                                ),
                              if (!_locationToggler)
                                TextFormField(
                                  controller: _shopAddressController,
                                  key: ValueKey('shopaddress'),
                                  validator: (value) {
                                    if (value.isEmpty || value.length < 6) {
                                      return 'Please enter full address!';
                                    }
                                    return null;
                                  },
                                  decoration: LoginScreen.kinputDecoration,
                                ),
                              SizedBox(
                                height: 11.0,
                              ),
                              if (!_locationToggler)
                                Text(
                                  'Pin code',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17.0,
                                    color: Colors.white,
                                  ),
                                ),
                              if (!_locationToggler)
                                SizedBox(
                                  height: 8.0,
                                ),
                              if (!_locationToggler)
                                TextFormField(
                                  controller: _pinCodeController,
                                  key: ValueKey('pincode'),
                                  validator: (value) {
                                    if (value.isEmpty || value.length < 6) {
                                      return 'enter a valid pin code!';
                                    }
                                    return null;
                                  },
                                  decoration: LoginScreen.kinputDecoration,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(10.0),
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _saving = true;
                        });

                        final _isValid = _formKey.currentState.validate();

                        if (_isValid) {
                          !_locationToggler
                              ? _storeData
                                  .collection('sellers')
                                  .doc(_auth.currentUser.email)
                                  .collection('single_seller')
                                  .doc('seller_details')
                                  .set({
                                    'email_address': _auth.currentUser.email,
                                    'seller_name': _sellerNameController.text,
                                    'mobile_number':
                                        _mobileNumberController.text,
                                    'shop_name': _shopNameController.text,
                                    'gst_number': _gstNumberController.text,
                                    'shop_address': _shopAddressController.text,
                                    'pin_code': _pinCodeController.text,
                                  })
                                  .then((value) => Navigator.of(context)
                                      .pushReplacementNamed(
                                          HomeOverviewScreen.id,
                                          arguments: _shopNameController.text))
                                  .catchError((onError) => print(onError))
                              : _storeData
                                  .collection('seller')
                                  .doc(_auth.currentUser.email)
                                  .collection('single_seller')
                                  .doc('seller_details')
                                  .set({
                                    'email_address': _auth.currentUser.email,
                                    'seller_name': _sellerNameController.text,
                                    'mobile_number':
                                        _mobileNumberController.text,
                                    'shop_name': _shopNameController.text,
                                    'gst_number': _gstNumberController.text,
                                    'shop_address':
                                        shopLocality + ' ' + shopAddress,
                                    'pin_code': shopPostalCode,
                                  })
                                  .then((value) => Navigator.of(context)
                                      .pushReplacementNamed(
                                          HomeOverviewScreen.id,
                                          arguments: _shopNameController.text))
                                  .catchError((onError) => print(onError));

                          setState(() {
                            _saving = false;
                          });
                        }
                        setState(() {
                          _saving = false;
                        });
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
                            'Proceed',
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
                      height: 30.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
