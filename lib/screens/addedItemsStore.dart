import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddedProductsStore extends StatefulWidget {
  @override
  _AddedProductsStoreState createState() => _AddedProductsStoreState();
}

class _AddedProductsStoreState extends State<AddedProductsStore> {
  FirebaseFirestore _virtualStore = FirebaseFirestore.instance;

  String _sellerEmail = FirebaseAuth.instance.currentUser.email;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _virtualStore
          .collection('total_store')
          .doc('seller')
          .collection(_sellerEmail)
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
            bool _hidden = document[index]['is_hidden'];

            return Card(
              elevation: 10.0,
              margin: EdgeInsets.all(10.0),
              color: Color(0xff1a1a2e),
              child: Container(
                padding: EdgeInsets.only(bottom: 18.0),
                child: Column(
                  children: [
                    Chip(
                      backgroundColor:
                          !_hidden ? Color(0xff81b214) : Color(0xffd92027),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        letterSpacing: 2.0,
                      ),
                      label:
                          Text(document[index]['category_label'].toUpperCase()),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
