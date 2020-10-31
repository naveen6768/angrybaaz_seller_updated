import '../screens/itemOverviewScreen.dart';
import 'package:flutter/material.dart';

class SingleCategory extends StatelessWidget {
  static const id = 'SingleCategory';

  final String imageUrl;
  final String categoryLabel;

  SingleCategory({this.categoryLabel, this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ItemOverviewScreen.id, arguments: categoryLabel);
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(17.0),
          ),
        ),
        child: Wrap(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  height: 80.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(imageUrl),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                categoryLabel,
                style: TextStyle(
                  // backgroundColor: Colors.black54,
                  color: Color(0xff373a40),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
