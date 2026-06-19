import 'package:flutter/material.dart';
import 'package:grafos/model/modelo_nodo.dart';
class DibujaNodo extends CustomPainter{

  List<ModeloNodo> nodos;
  DibujaNodo(this.nodos);
  
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
    .. style = PaintingStyle.fill;

    for (var ele in nodos) {
      canvas.drawCircle(Offset(ele.x, ele.y), ele.radio, paint..color = ele.color);
    }
  
}

@override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}