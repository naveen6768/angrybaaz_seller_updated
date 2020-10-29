import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class ItemOverviewScreen extends StatelessWidget {
  static const id = 'ItemOverviewScreen';
  @override
  Widget build(BuildContext context) {
    String categoryName = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(categoryName),
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}
