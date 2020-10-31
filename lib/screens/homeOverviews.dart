import 'package:flutter/material.dart';
import '../widgets/singleCategory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeOverview extends StatefulWidget {
  @override
  _HomeOverviewState createState() => _HomeOverviewState();
}

class _HomeOverviewState extends State<HomeOverview> {
  FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  String _sellerEmail = FirebaseAuth.instance.currentUser.email;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
              sellerEmail: _sellerEmail,
            ),
          ),
        );
      },
    );
  }
}
