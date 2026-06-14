import 'package:flutter/material.dart';

class Anialign extends StatefulWidget {
  const Anialign({super.key});

  @override
  State<Anialign> createState() => _AnialignState();
}

class _AnialignState extends State<Anialign> {
  Curve curva = Curves.easeInOutQuint;
  double x = 0;
  double y = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 1000),
            curve: curva,
            onEnd: () {
              setState(() {
                if (y == -1) {
                  curva = Curves.bounceOut;
                  y = 1;
                }
              });
            },
            alignment: Alignment(x, y),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: RadialGradient(
                  colors: [Colors.white, Colors.black],
                ),
              ),
            ),
          )
        ]
      ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                curva = Curves.easeInOutQuint;
                y = -1;
              });
            },
            child: const Icon(Icons.play_arrow),
          ),
    );
  }
}