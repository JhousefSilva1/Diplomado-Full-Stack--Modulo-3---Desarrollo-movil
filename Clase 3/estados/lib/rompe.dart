import 'package:flutter/material.dart';

class Rompe extends StatefulWidget {
  const Rompe({super.key});

  @override
  State<Rompe> createState() => _RompeState();
}

class _RompeState extends State<Rompe> {
  double lero=100;
  double leve=200;


  void swap(){
    double temp=lero;
    lero=leve;
    leve=temp;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rompecocos'),),
        body: Stack(
            children:[
              AnimatedPositioned(
                duration: Duration(milliseconds: 1000),
                
                left: lero,
                top: 200,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      print('Tocaste el rojo');
                      SnackBar snackBar = SnackBar(content: Text('Tocaste el rojo'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      // MOVER EL ROJO A OTRA POSICION
                      swap();
                
                      
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.red,
                  
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 1000),
                left: leve,
                top: 200,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      print('Tocaste el VERDE');
                      SnackBar snackBar = SnackBar(content: Text('Tocaste el verde'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      // MOVER EL VERDE A OTRA POSICION
                      swap();
                
                      
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.green,
                  
                  ),
                ),
              )
            ]
        )
      
    );
  }
}