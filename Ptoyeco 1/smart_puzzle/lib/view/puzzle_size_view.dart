import 'package:flutter/material.dart';
import 'package:smart_puzzle/view/app_bar.dart';
import 'package:smart_puzzle/view/letter_puzzle_view.dart';
import 'package:smart_puzzle/view/number_puzzle_view.dart';

class PuzzleSizeView extends StatefulWidget {
  final String selectedPuzzle;

  const PuzzleSizeView({
    super.key,
    required this.selectedPuzzle,
  });

  @override
  State<PuzzleSizeView> createState() => _PuzzleSizeViewState();
}

class _PuzzleSizeViewState extends State<PuzzleSizeView> {
  int selectedSize = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PuzzleAppBar(
        title: 'Nivel de dificultad',
        showBackButton: true,
      ),
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                Text(
                  widget.selectedPuzzle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Escoge el tamaño del puzzle',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      _buildSizeOption(
                        size: 3,
                        title: 'Fácil',
                        subtitle: '3 x 3',
                        icon: Icons.sentiment_satisfied_alt,
                      ),
                      _buildSizeOption(
                        size: 4,
                        title: 'Normal',
                        subtitle: '4 x 4',
                        icon: Icons.extension,
                      ),
                      _buildSizeOption(
                        size: 5,
                        title: 'Difícil',
                        subtitle: '5 x 5',
                        icon: Icons.psychology,
                      ),
                      _buildSizeOption(
                        size: 6,
                        title: 'Experto',
                        subtitle: '6 x 6',
                        icon: Icons.local_fire_department,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (widget.selectedPuzzle == 'Numbers Puzzle') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NumberPuzzleView(
                              size: selectedSize,
                            ),
                          ),
                        );
                      } else if (widget.selectedPuzzle == 'Letters Puzzle') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LetterPuzzleView(
                              size: selectedSize,
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text(
                      'Jugar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSizeOption({
    required int size,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    bool isSelected = selectedSize == size;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = size;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.white30,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 42,
              color: isSelected ? Colors.deepPurple : Colors.white,
            ),

            const SizedBox(height: 12),

            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.deepPurple : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              subtitle,
              style: TextStyle(
                color: isSelected
                    ? Colors.deepPurple.withValues(alpha: 0.75)
                    : Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}