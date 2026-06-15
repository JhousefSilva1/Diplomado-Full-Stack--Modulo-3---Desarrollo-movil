import 'package:flutter/material.dart';

class DibujaPunto extends CustomPainter{
  double x;
  double y;
  double radio;

  DibujaPunto(
    this.x,
    this.y, 
    this.radio);


  @override
  void paint(Canvas canvas, Size size) {
    Paint brocha = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.red;

    canvas.drawCircle(Offset(x, y), radio, brocha);

  
}

@override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}