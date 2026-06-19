import 'package:flutter/material.dart';
import 'package:my_paint/model/modelo_punto.dart';

class DibujaPunto extends CustomPainter{
  // double x;
  // double y;
  // double radio;

  // DibujaPunto(
  //   this.x,
  //   this.y, 
  //   this.radio);

  List<ModeloPunto> puntos;
  DibujaPunto(this.puntos);


  @override
  void paint(Canvas canvas, Size size) {
    Paint brocha = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.red;

    for (var ele in puntos) {
      brocha.color = ele.color;
      canvas.drawCircle(Offset(ele.x, ele.y), ele.radio, brocha);
    }

    // canvas.drawCircle(Offset(x, y), radio, brocha);
    

  
}

@override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}