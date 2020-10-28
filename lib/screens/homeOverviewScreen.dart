import 'package:angrybaaz_seller/screens/becomePartner.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class HomeOverviewScreen extends StatefulWidget {
  static const id = 'HomeOverviewScreen';

  @override
  _HomeOverviewScreenState createState() => _HomeOverviewScreenState();
}

class _HomeOverviewScreenState extends State<HomeOverviewScreen> {
  final String _currentUserEmail = FirebaseAuth.instance.currentUser.email;
// GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final String shop_name = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      // key: _drawerKey,
      drawer: Drawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          shop_name,
          style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection(
                '/seller/${_currentUserEmail.toLowerCase().trim()}/single_seller')
            .snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = streamSnapshot.data.documents;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (ctx, index) => Container(
              padding: EdgeInsets.all(8),
              child: Text(documents[index]['gst_number']),
            ),
          );
        },
      ),
    );
  }
}
