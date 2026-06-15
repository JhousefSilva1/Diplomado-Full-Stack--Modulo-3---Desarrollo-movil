import 'package:flutter/material.dart';

class ShapePuzzleView extends StatefulWidget {
  const ShapePuzzleView({super.key});

  @override
  State<ShapePuzzleView> createState() => _ShapePuzzleViewState();
}

class _ShapePuzzleViewState extends State<ShapePuzzleView> {
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
            'Shapes Puzzle',
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