import 'package:flutter/material.dart';

class RaizedText extends StatelessWidget {
  final String text;
  final Color col;
  final double rad;

  const RaizedText(
      {@required this.text, this.col = Colors.black, this.rad = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          //background color of box
          BoxShadow(
            color: col.withOpacity(0.3),
            blurRadius: 5.0, // soften the shadow
            spreadRadius: .5, //extend the shadow
            offset: Offset(
              1.0, // Move to right 10  horizontally
              1.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(color: col),
        ),
      ),
    );
  }
}
