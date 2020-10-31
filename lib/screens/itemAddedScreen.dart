// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ItemAddedScreen extends StatefulWidget {
//   static const id = 'ItemAddedScreen';
//   @override
//   _ItemAddedScreenState createState() => _ItemAddedScreenState();
// }

// class _ItemAddedScreenState extends State<ItemAddedScreen> {
//   FirebaseFirestore _itemData = FirebaseFirestore.instance;
//   String catName;
//   String sellerEmail;
//   String specificItemName;
//   @override
//   Widget build(BuildContext context) {
//     List sellerPrivateData = ModalRoute.of(context).settings.arguments;
//     sellerEmail = sellerPrivateData[1];
//     catName = sellerPrivateData[0];
//     specificItemName = sellerPrivateData[2];
//     // print(specificItemName);
//     return Scaffold(
//       body: StreamBuilder(
//         stream: _itemData
//             .collection('main_category')
//             .doc('bands')
//             .collection('subscribed_sellers')
//             .snapshots(),
//         builder: (context, streamSnapshot) {
//           if (streamSnapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           final documents = streamSnapshot.data.documents;
//           // print(documents);
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ListView.builder(
//               itemCount: documents.length,
//               itemBuilder: (ctx, index) => Container(
//                 child: Text(documents[0]['printing_band']['item_desription']),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
