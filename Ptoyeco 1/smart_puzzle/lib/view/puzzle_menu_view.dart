import 'package:flutter/material.dart';
import 'package:smart_puzzle/view/app_bar.dart';


class PuzzleMenuView  extends StatefulWidget {
  const PuzzleMenuView({super.key});

  @override
  State<PuzzleMenuView> createState() => _PuzzleMenuViewState();
}

class _PuzzleMenuViewState extends State<PuzzleMenuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PuzzleAppBar(
        title: 'Puzzle Menu',
        showBackButton: false,
      ),
      body: Center(
        child: Text('Menu de Puzzles'),
      )
    );
  }
}