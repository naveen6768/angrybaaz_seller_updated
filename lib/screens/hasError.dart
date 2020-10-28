import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HasError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Lottie.network(
          'https://assets7.lottiefiles.com/packages/lf20_f1cFsO.json'),
    );
  }
}
