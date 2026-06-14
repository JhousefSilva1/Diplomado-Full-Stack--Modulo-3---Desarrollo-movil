import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.teal.shade200,
        appBar: AppBar(title: Text('AppBar'), backgroundColor: Colors.teal.shade400,
          
        ),
        body: Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border:Border.all(color: Colors.black, width: 2),
              gradient: LinearGradient(
                
                colors: const [
                  Colors.red,
                  Colors.yellow,
                  Colors.green,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            ),
           
            child: Center(
              child: Text('Bolivia', style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
            ),
          ),
        )
      ),
    );
  }
}
