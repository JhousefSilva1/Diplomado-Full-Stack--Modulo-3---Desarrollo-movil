import 'package:flutter/material.dart';

class NumberMiniPuzzleBoard extends StatelessWidget {
  final int size;
  final List<int> state;

  const NumberMiniPuzzleBoard({
    super.key,
    required this.size,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    double fontSize = 18;

    if (size == 3) {
      fontSize = 22;
    } else if (size == 4) {
      fontSize = 18;
    } else if (size == 5) {
      fontSize = 14;
    } else if (size >= 6) {
      fontSize = 11;
    }

    double spacing = size >= 5 ? 3 : 5;
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
          int piece = state[index];

          if (piece == 0) {
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
                piece.toString(),
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