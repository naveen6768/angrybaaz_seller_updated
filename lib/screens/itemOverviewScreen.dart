import 'dart:io';
import 'dart:async';
import 'package:angrybaaz_seller/screens/homeOverviewScreen.dart';
import 'package:angrybaaz_seller/screens/itemAddedScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:provider/provider.dart';

class ItemOverviewScreen extends StatefulWidget {
  static const id = 'ItemOverviewScreen';

  @override
  _ItemOverviewScreenState createState() => _ItemOverviewScreenState();
}

class _ItemOverviewScreenState extends State<ItemOverviewScreen> {
  bool itemInStock = true;
  String sellerEmailAddress;
  String categoryName;
  PickedFile _image;
  bool _colorToggler = true;
  String _linkGot;

  bool _successMessageToggler = false;
  TextEditingController _materialTypeController = TextEditingController();
  TextEditingController _specificItemTypeController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  int _pressCounter = 0;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseFirestore _dataStore = FirebaseFirestore.instance;

  Future getImage() async {
    PickedFile pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        print('image inide _image');
        _image = PickedFile(pickedFile.path);
      } else {
        print('No image selected.');
        sleep(Duration(seconds: 3));
      }
    });
  }

  Future uploadImageToFirebaseStorage(
    BuildContext ctx,
  ) async {
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
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List sellerPrivateData = ModalRoute.of(context).settings.arguments;
    sellerEmailAddress = sellerPrivateData[1];
    categoryName = sellerPrivateData[0];
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(categoryName),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // StreamBuilder(builder: null)
                Center(
                  child: Text(
                    ' Add single item of this category ',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 20.0,
                        backgroundColor: Colors.blue[800]),
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
                      bool _isvalid = _formKey.currentState.validate();
                      if (_isvalid) {
                        _dataStore
                            .collection('main_category')
                            .doc(categoryName)
                            .collection('subscribed_sellers')
                            .doc(sellerEmailAddress)
                            .set({
                          _specificItemTypeController.text: {
                            'stock_is_available': itemInStock,
                            'item_imageUrl': _linkGot,
                            'material_used_in_item':
                                _materialTypeController.text,
                            'price_per_piece': _priceController.text,
                            'item_description': _descriptionController.text,
                          }
                        }).then((value) {
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text('New item uploaded successfully!'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          setState(() {
                            _formKey.currentState.reset();
                          });
                          // Navigator.of(context)
                          //     .pushNamed(ItemAddedScreen.id, arguments: [
                          //   categoryName,
                          //   sellerEmailAddress,
                          //   _specificItemTypeController.text
                          // ]);
                        });
                        FocusScope.of(context).unfocus();
                      }
                    },
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
    );
  }
}
