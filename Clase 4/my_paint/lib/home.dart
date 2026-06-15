import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double x = 0;
  double y = 0;
  double radio = 10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Paint'),
      ),
      body: Stack(
        children: [
          CustomPaint(
            painter: DibujaPunto(x,y,radio),
          )
        ],
        
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [

          ],
        )
      ),
    );
  }
}