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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate to the puzzle view
                },
                child: const Text('Numbers Puzzle'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the puzzle view
                },
                child: const Text('Letters Puzzle'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the puzzle view
                },
                child: const Text('Colors Puzzle'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the puzzle view
                },
                child: const Text('Shapes Puzzle'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the puzzle view
                },
                child: const Text('Images Puzzle'),
              ),
            ],
          ),
        )
      );
  }
}