import 'dart:math' as math;

import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade900,
      appBar: AppBar(
        title:  Text('Botones'),
        backgroundColor: Colors.purple.shade700,
      ),
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(150),
              bottomRight: Radius.circular(150),
            ),
            gradient: LinearGradient(
              colors:[
                Color.fromARGB(1000, 0, 10, 0),
                Color.fromARGB(1000, 0, 90, 0),
                Color.fromARGB(1000, 0, 170, 0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Transform.rotate(
              angle: 7* math.pi / 4,
              child: Text(
                'Botón',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ),
          ),
        )
      )
    );
        
  
 
  }
}