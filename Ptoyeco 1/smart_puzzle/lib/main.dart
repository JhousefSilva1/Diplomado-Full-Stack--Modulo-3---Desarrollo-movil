import 'package:flutter/material.dart';
import 'package:smart_puzzle/view/puzzle_menu_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PuzzleMenuView(),
    );
  }
}
