import 'dart:io';
import 'dart:async';
import 'package:angrybaaz_seller/widgets/homeScreenDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/singleCategory.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeOverviewScreen extends StatefulWidget {
  static const id = 'HomeOverviewScreen';
  static const kdecoration = InputDecoration(
    fillColor: Color(0xffF0F0F0),
    filled: true,
    hintText: '',
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white30, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black45, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  );

  @override
  _HomeOverviewScreenState createState() => _HomeOverviewScreenState();
}

class _HomeOverviewScreenState extends State<HomeOverviewScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  String _sellerEmail;

  // void getModalSheet(ctx) {
  //   showModalBottomSheet(
  //     context: ctx,
  //     builder: (
  //       ctx,
  //     ) {
  //       return BottomContainer(ictx: ctx, sKey: _scaffoldKey);
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    _sellerEmail = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      key: _scaffoldKey,
      drawer: HomeScreenDrawer(_sellerEmail),
      backgroundColor: Colors.white,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color(0xffcf7500),
      //   onPressed: () {
      //     getModalSheet(context);
      //   },
      //   child: Icon(Icons.add),
      // ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('create_store!'),
      ),
      body: StreamBuilder(
        stream: _firestoreInstance.collection('main_category').snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = streamSnapshot.data.documents;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3 / 3,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: documents.length,
              itemBuilder: (ctx, index) => SingleCategory(
                categoryLabel: documents[index]['category_name'],
                imageUrl: documents[index]['imageUrl'],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BottomContainer extends StatefulWidget {
  final BuildContext ictx;
  final GlobalKey<ScaffoldState> sKey;
  BottomContainer({
    this.ictx,
    this.sKey,
  });

  @override
  _BottomContainerState createState() => _BottomContainerState();
}

class _BottomContainerState extends State<BottomContainer> {
  PickedFile _image;
  bool _colorToggler = true;
  String _linkGot;
  bool _successMessageToggler = false;
  final ImagePicker _picker = ImagePicker();
  int _pressCounter = 0;
  TextEditingController _categoryNameController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  Future uploadImageToFirebaseStorage(BuildContext ctx, sKey) async {
    List pathList = _image.path.split('/');
    int len = pathList.length;
    String fileName = pathList.elementAt(len - 1).toString();
    print(fileName);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('mainCategoryImages/$fileName');
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
    return Container(
      color: Color(0xff757575),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(23.0),
            topRight: Radius.circular(23.0),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 30.0,
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_image != null)
                  Text(
                    'Enter category name',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black26,
                    ),
                  ),
                if (_image != null)
                  SizedBox(
                    height: 7.0,
                  ),
                if (_image != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter valid name';
                        }
                        return null;
                      },
                      controller: _categoryNameController,
                      decoration: HomeOverviewScreen.kdecoration,
                    ),
                  ),
                if (_image != null)
                  SizedBox(
                    height: 10.0,
                  ),
                if (_image == null)
                  Container(
                    // color: Colors.red,
                    height: 250.0,
                    child: Lottie.network(
                        'https://assets10.lottiefiles.com/packages/lf20_GxMZME.json'),
                  ),
                if (_image != null)
                  SizedBox(
                    height: 5.0,
                  ),
                if (_image != null)
                  Stack(
                    children: [
                      Container(
                        height: 170.0,
                        width: 170.0,
                        decoration: BoxDecoration(
                          // color: Colors.black,
                          borderRadius: BorderRadius.circular(10.0),
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
                                  uploadImageToFirebaseStorage(
                                      context, widget.sKey);
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
                if (_image != null)
                  SizedBox(
                    height: 13.0,
                  ),
                if (_image != null)
                  if (_successMessageToggler)
                    Text(
                      'You can Proceed!',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.blue[800],
                          letterSpacing: 2.5),
                    ),
                if (_image != null)
                  SizedBox(
                    height: 5.0,
                  ),
                if (_image == null)
                  Text(
                    'Image Upload !!',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                if (_image != null)
                  SizedBox(
                    height: 10.0,
                  ),
                if (_image != null)
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      bool _isValid = _formKey.currentState.validate();
                      if (_isValid) {
                        _dataStore
                            .collection('main_category')
                            .doc(_categoryNameController.text)
                            .set({
                          'category_name': _categoryNameController.text,
                          'imageUrl': _linkGot,
                        }).then((value) =>
                                widget.sKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      'New category uploaded successfully!'),
                                  duration: Duration(seconds: 3),
                                )));
                      }
                      Navigator.pop(widget.ictx);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 63.0),
                      child: Text(
                        'Create Instance',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                if (_image == null) Spacer(),
                if (_image == null)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Card(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black26,
                            width: 1.5,
                          ),
                          // color: Color(0xff373a40),
                          color: Color(0xffcf7500),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.add_a_photo,
                              size: 30.0,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              getImage();
                            },
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
    );
  }
}

// if (_firestoreInstance
//         .collection('main_category')
//         .snapshots()
//         .length ==
//     0)
//   Text('yeah'),
// SizedBox(
//   height: 20.0,
// ),
// Container(
//   // color: Colors.red,
//   height: 250.0,
//   child: Lottie.network(
//       'https://assets2.lottiefiles.com/datafiles/wqxpXEEPRQf1JnQ/data.json'),
// ),
// SizedBox(
//   height: 60.0,
// ),
// Center(
//   child: Card(
//     elevation: 6.0,
//     // color: Theme.of(context).primaryColor,
//     color: Color(0xff373a40),
//     child: Padding(
//       padding: const EdgeInsets.symmetric(
//         vertical: 13.0,
//         horizontal: 15.0,
//       ),
//       child: Container(
//         child: Text(
//           'Click + to initiate new category!!',
//           style: TextStyle(
//             letterSpacing: 0.5,
//             fontSize: 16.0,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     ),
//   ),
// ),
