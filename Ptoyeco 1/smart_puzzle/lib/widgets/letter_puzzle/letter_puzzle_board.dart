import 'package:flutter/material.dart';

class LetterPuzzleBoard extends StatelessWidget {
  final int size;
  final List<String> pieces;
  final String? lastMovedPiece;
  final bool Function(int index) canMovePiece;
  final void Function(int index) onPieceTap;

  const LetterPuzzleBoard({
    super.key,
    required this.size,
    required this.pieces,
    required this.lastMovedPiece,
    required this.canMovePiece,
    required this.onPieceTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        itemCount: pieces.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: size,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          String piece = pieces[index];

          if (piece == '') {
            return _buildEmptyPiece();
          }

          bool isMovable = canMovePiece(index);
          bool isLastMoved = lastMovedPiece == piece;

          return GestureDetector(
            onTap: () {
              onPieceTap(index);
            },
            child: AnimatedScale(
              scale: isLastMoved ? 1.08 : 1.0,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutBack,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                decoration: _pieceDecoration(isMovable),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: Center(
                    key: ValueKey(piece),
                    child: Text(
                      piece,
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: size >= 6
                            ? 16
                            : size >= 5
                                ? 22
                                : 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyPiece() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
    );
  }

  BoxDecoration _pieceDecoration(bool isMovable) {
    return BoxDecoration(
      color: isMovable ? Colors.amber.withValues(alpha: 0.95) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isMovable ? Colors.white : Colors.transparent,
        width: isMovable ? 2 : 0,
      ),
      boxShadow: [
        BoxShadow(
          color: isMovable
              ? Colors.amber.withValues(alpha: 0.55)
              : Colors.black.withValues(alpha: 0.25),
          blurRadius: isMovable ? 14 : 6,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}