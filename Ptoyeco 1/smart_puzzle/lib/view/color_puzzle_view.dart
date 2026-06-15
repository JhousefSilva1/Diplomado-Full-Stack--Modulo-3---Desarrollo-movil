import 'package:flutter/material.dart';

class ColorPuzzleView extends StatefulWidget {
  const ColorPuzzleView({super.key});

  @override
  State<ColorPuzzleView> createState() => _ColorPuzzleViewState();
}

class _ColorPuzzleViewState extends State<ColorPuzzleView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4A148C),
              Color(0xFF7B1FA2),
              Color(0xFFBA68C8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Text(
            'Colors Puzzle',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}