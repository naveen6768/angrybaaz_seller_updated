import 'dart:io';
import 'dart:async';
import 'package:angrybaaz_seller/screens/homeOverviewScreen.dart';
// import 'package:angrybaaz_seller/screens/itemAddedScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ItemOverviewScreen extends StatefulWidget {
  static const id = 'ItemOverviewScreen';

  @override
  _ItemOverviewScreenState createState() => _ItemOverviewScreenState();
}

class _ItemOverviewScreenState extends State<ItemOverviewScreen> {
  bool itemInStock = true;
  bool _isLoader = false;
  bool _isLoading = false;
  String categoryName;
  PickedFile _image;
  bool _colorToggler = true;
  String _linkGot;
  bool _hiddenToggler = false;
  bool _successMessageToggler = false;
  TextEditingController _materialTypeController = TextEditingController();
  TextEditingController _specificItemTypeController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String _sEmail = FirebaseAuth.instance.currentUser.email;
  int _pressCounter = 0;
  FirebaseFirestore _dataStore = FirebaseFirestore.instance;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _switchToggler;
  Future getImage() async {
    PickedFile pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        print('image inide _image');
        _image = PickedFile(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImageToFirebaseStorage(
    BuildContext ctx,
  ) async {
    setState(() {
      _isLoading = true;
    });
    List pathList = _image.path.split('/');
    int len = pathList.length;
    String fileName = pathList.elementAt(len - 1).toString();
    print(fileName);
    StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('sellerChoosenCategory/sellerStoreItemImages/$fileName');
    StorageUploadTask uploadTask =
        firebaseStorageRef.putFile(File(_image.path));
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
      (value) {
        _linkGot = value;
        print("Done:$value");
        setState(() {
          _successMessageToggler = true;
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    categoryName = ModalRoute.of(context).settings.arguments;
    Widget buildSlidingPanel({
      @required ScrollController scrollController,
    }) =>
        ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(10.0),
                controller: scrollController,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff373a40),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          ' Add item ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            // backgroundColor: Colors.blue[800]
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    '$categoryName type',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w900,
                      fontSize: 16.0,
                      color: Color(0xff968c83),
                    ),
                  ),
                  SizedBox(
                    height: 7.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid item type!';
                      }
                      return null;
                    },
                    controller: _specificItemTypeController,
                    decoration: HomeOverviewScreen.kdecoration,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    'Upload image',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w900,
                      fontSize: 16.0,
                      color: Color(0xff968c83),
                    ),
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  if (_image == null)
                    Center(
                      child: RaisedButton(
                        onPressed: () {
                          getImage();
                        },
                        child: Text('Item image upload'),
                      ),
                    ),
                  if (_image != null && _colorToggler == true)
                    Text(
                      'Click on the yellow icon to upload it to the angrybaaz server!!',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(
                    height: 20.0,
                  ),
                  if (_image != null)
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            height: 170.0,
                            width: 170.0,
                            decoration: BoxDecoration(
                              // color: Colors.black,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: _image == null
                                ? null
                                : Image.file(
                                    File(_image.path),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                            // bottom: 130,
                            left: 57.0,
                            top: 105,
                            child: FloatingActionButton(
                              elevation: 20.0,
                              backgroundColor: _colorToggler
                                  ? Color(0xffcf7500)
                                  : Theme.of(context).primaryColor,
                              onPressed: _pressCounter < 1
                                  ? () {
                                      uploadImageToFirebaseStorage(context);
                                      _pressCounter++;
                                      setState(() {
                                        _colorToggler = false;
                                      });
                                    }
                                  : null,
                              child: Icon(
                                Icons.upload_file,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_image != null)
                    SizedBox(
                      height: 13.0,
                    ),
                  if (_image != null)
                    if (_successMessageToggler)
                      Center(
                        child: Text(
                          'You can Proceed!',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.blue[800],
                              letterSpacing: 2.5),
                        ),
                      ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Material type',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                      color: Color(0xff968c83),
                    ),
                  ),
                  SizedBox(
                    height: 7.0,
                  ),
                  TextFormField(
                    decoration: HomeOverviewScreen.kdecoration,
                    controller: _materialTypeController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter valid material name!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 17.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'Price/piece(Rs.)-',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff968c83),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: HomeOverviewScreen.kdecoration,
                          controller: _priceController,
                          validator: (value) {
                            if (value.isEmpty ||
                                value.contains(new RegExp(r'[a-z]'))) {
                              return 'Enter valid price!';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                      color: Color(0xff968c83),
                    ),
                  ),
                  SizedBox(
                    height: 7.0,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter description';
                      }
                      return null;
                    },
                    decoration: HomeOverviewScreen.kdecoration,
                    keyboardType: TextInputType.multiline,
                    minLines: 2, //Normal textInputField will be displayed
                    maxLines: 4, // when user presses enter it will adapt to it
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Center(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Proceed',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        bool _isvalid = _formKey.currentState.validate();

                        if (_isvalid) {
                          _dataStore
                              .collection('main_category')
                              .doc(categoryName)
                              .collection(_sEmail)
                              .doc(_specificItemTypeController.text)
                              .set({
                            'item_type': _specificItemTypeController.text,
                            'stock_is_available': itemInStock,
                            'item_imageUrl': _linkGot,
                            'material_used_in_item':
                                _materialTypeController.text,
                            'price_per_piece': _priceController.text,
                            'item_description': _descriptionController.text,
                          }).then((value) {
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content:
                                    Text('New item uploaded successfully!'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            setState(() {
                              _formKey.currentState.reset();
                            });
                          });
                          _dataStore
                              .collection('total_store')
                              .doc('seller')
                              .collection(_sEmail)
                              .doc(_specificItemTypeController.text)
                              .set({
                            'is_hidden': _hiddenToggler,
                            'category_label': categoryName,
                            'item_type': _specificItemTypeController.text,
                            'stock_is_available': itemInStock,
                            'item_imageUrl': _linkGot,
                            'material_used_in_item':
                                _materialTypeController.text,
                            'price_per_piece': _priceController.text,
                            'item_description': _descriptionController.text,
                          }).then((value) => print('added'));

                          _dataStore
                              .collection('total_store')
                              .doc('cat_specific_sellers')
                              .collection(categoryName)
                              .doc(_specificItemTypeController.text)
                              .set({
                            'seller_Email': _sEmail,
                            'item_type': _specificItemTypeController.text,
                            'stock_is_available': itemInStock,
                            'item_imageUrl': _linkGot,
                            'material_used_in_item':
                                _materialTypeController.text,
                            'price_per_piece': _priceController.text,
                            'item_description': _descriptionController.text,
                          }).then((value) => print('added'));
                          FocusScope.of(context).unfocus();
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 250.0,
                  ),
                ],
              ),
            ),
          ),
        );
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(categoryName),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoader,
        child: SlidingUpPanel(
          minHeight: 40.0,
          // parallaxEnabled: true,
          backdropEnabled: true,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          panelBuilder: (scrollController) => buildSlidingPanel(
            scrollController: scrollController,
          ),
          body: StreamBuilder(
            stream: _dataStore
                .collection('main_category')
                .doc(categoryName)
                .collection(_sEmail)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final document = snapshot.data.documents;
              return ListView.builder(
                  itemCount: document.length,
                  itemBuilder: (context, index) {
                    _switchToggler = document[index]['stock_is_available'];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      elevation: 6.0,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 100.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Colors.red,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            document[index]['item_imageUrl']),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Category type - ${document[index]['item_type']}',
                                        style: TextStyle(
                                          color: Color(0xff968c83),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        'Price/piece-  Rs.${document[index]['price_per_piece']}',
                                        style: TextStyle(
                                          color: Color(0xff968c83),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        'Material used - ${document[index]['material_used_in_item']}',
                                        style: TextStyle(
                                          color: Color(0xff968c83),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Stock is available?',
                                    style: TextStyle(
                                      color: Color(0xff968c83),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Spacer(),
                                  Switch(
                                    activeColor: Colors.lightGreen,
                                    value: _switchToggler,
                                    onChanged: (value) {
                                      setState(() {
                                        _switchToggler = value;
                                      });
                                      setState(() {
                                        _isLoader = true;
                                      });
                                      _dataStore
                                          .collection('main_category')
                                          .doc(categoryName)
                                          .collection(_sEmail)
                                          .doc(document[index]['item_type'])
                                          .update(
                                              {'stock_is_available': value});
                                      if (!document[index]
                                          ['stock_is_available']) {
                                        _dataStore
                                            .collection('total_store')
                                            .doc('seller')
                                            .collection(_sEmail)
                                            .doc(document[index]['item_type'])
                                            .update({'is_hidden': false});
                                      }
                                      if (document[index]
                                          ['stock_is_available']) {
                                        _dataStore
                                            .collection('total_store')
                                            .doc('seller')
                                            .collection(_sEmail)
                                            .doc(document[index]['item_type'])
                                            .update({'is_hidden': true});
                                      }
                                      setState(() {
                                        _isLoader = false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}
