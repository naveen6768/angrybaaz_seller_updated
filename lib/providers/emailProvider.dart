import 'package:flutter/material.dart';

class EmailProvider with ChangeNotifier {
  final String sellerEmail;
  EmailProvider(this.sellerEmail);
}
