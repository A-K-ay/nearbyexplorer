import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularSVGIcon extends StatelessWidget {
  final Color col;
  final double rad, height;
  final String url;
  final Function fuc;

  const CircularSVGIcon(
      {this.fuc,
      this.col = Colors.black,
      this.height = 35,
      this.rad = 20,
      @required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fuc,
      child: Container(
        height: height + 16,
        width: height + 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(rad),
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
            child: SvgPicture.asset(
              url,
              height: height,
            )),
      ),
    );
  }
}
