import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  final Color col;
  final double rad, size;
  final IconData icon;
  final Function fuc;

  const CircularIconButton(
      {this.fuc,
      this.col = Colors.black,
      this.size,
      this.rad = 20,
      @required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fuc,
      child: Container(
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
          child: Icon(
            icon,
            size: size,
            color: col,
          ),
        ),
      ),
    );
  }
}
