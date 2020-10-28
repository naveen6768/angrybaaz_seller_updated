import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ConnectionWaiting extends StatelessWidget {
  final BuildContext ctx;
  ConnectionWaiting({this.ctx});
  @override
  Widget build(BuildContext context) {
    // print('yeha');
    return Container(
      color: Colors.white,
      height: 200.0,
      width: 200.0,
      child: Lottie.network(
          'https://assets5.lottiefiles.com/packages/lf20_KXU9LM.json'),
    );
  }
}
