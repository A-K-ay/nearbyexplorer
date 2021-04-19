import 'package:flutter/material.dart';

import '../Responsive.dart';

class CustomButton extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  final String txt;
  final Function fuc;
  final Color col, txtCol;

  const CustomButton(
      {@required this.height,
      @required this.width,
      this.col = Colors.yellow,
      this.txtCol = Colors.black,
      this.radius = 10,
      this.fuc,
      this.txt = ""});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fuc,
      child: Container(
        width: getProportionateScreenWidth(width),
        height: getProportionateScreenHeight(height),
        decoration: BoxDecoration(
          color: col,
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
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
        child: Center(
            child: Text(
          txt,
          style: TextStyle(color: txtCol),
        )),
      ),
    );
  }
}
