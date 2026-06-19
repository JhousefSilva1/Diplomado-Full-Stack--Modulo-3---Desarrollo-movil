import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grafos/model/modelo_nodo.dart';
import 'package:grafos/model/shape/dibuja_nodo.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int nodo = -1;
  List<ModeloNodo> nodos = [];
  int position = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children:[
          CustomPaint(
            painter: DibujaNodo(nodos),
          ),
          GestureDetector(
            onPanDown: (des){
              setState(() {
              
              double x = des.localPosition.dx;
              double y = des.localPosition.dy;
              if(nodo == 1){
                nodos.add(ModeloNodo(x, y, 20, Colors.green));
              }else{
                if(nodo == 2){
                  position = buscarNodo(x, y);
                  if(position >=0){
                    nodos.removeAt(position);
                  }
                }
              }
              });
             
            },
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children:[
            CircleAvatar(
              backgroundColor: (nodo==1) ? 
              Colors.green :
              Colors.grey,
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed:(){
                  setState(() {
                    nodo = 1;
                  });
                }
              )
            ),
            SizedBox(width: 10,),

            CircleAvatar(
              backgroundColor: (nodo==2) ? 
              Colors.red :
              Colors.grey,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed:(){
                  setState(() {
                    nodo = 2;
                  });
                }
              )
            )
          ],
        )
      ),

    );
  }

  int buscarNodo(double x, double y){
    for(int i = 0; i < nodos.length; i++){
      double distance = sqrt(pow(x - nodos[i].x, 2) + pow(y - nodos[i].y, 2));
      if(distance < nodos[i].radio){
        return i;
      }
    }
    return -1;
  }
}