import 'package:flutter/material.dart';

class LetterMiniPuzzleBoard extends StatelessWidget {
  final int size;
  final List<String> state;

  const LetterMiniPuzzleBoard({
    super.key,
    required this.size,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    double fontSize = 22;

    if (size == 4) {
      fontSize = 20;
    } else if (size == 5) {
      fontSize = 15;
    } else if (size >= 6) {
      fontSize = 12;
    }

    double spacing = size >= 5 ? 3 : 4;
    double borderRadius = size >= 5 ? 6 : 8;

    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        itemCount: state.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: size,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemBuilder: (context, index) {
          String piece = state[index];

          if (piece == '') {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.30),
                ),
              ),
            );
          }

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Center(
              child: Text(
                piece,
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}