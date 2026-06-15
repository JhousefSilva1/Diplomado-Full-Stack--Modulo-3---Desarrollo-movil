import 'package:flutter/material.dart';
import 'package:smart_puzzle/view/app_bar.dart';
import 'package:smart_puzzle/view/color_puzzle_view.dart';
import 'package:smart_puzzle/view/image_puzzle_view.dart';
import 'package:smart_puzzle/view/letter_puzzle_view.dart';
import 'package:smart_puzzle/view/number_puzzle_view.dart';
import 'package:smart_puzzle/view/shape_puzzle_view.dart';

class PuzzleMenuView extends StatefulWidget {
  const PuzzleMenuView({super.key});

  @override
  State<PuzzleMenuView> createState() => _PuzzleMenuViewState();
}

class _PuzzleMenuViewState extends State<PuzzleMenuView> {
  String selectedPuzzle = 'Numbers Puzzle';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PuzzleAppBar(
        title: 'Puzzle Menu',
        showBackButton: false,
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

                const Text(
                  'Smart Puzzle',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Elige el tipo de puzzle que quieres jugar',
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
                      _buildPuzzleOption(
                        title: 'Numbers Puzzle',
                        icon: Icons.numbers,
                      ),
                      _buildPuzzleOption(
                        title: 'Letters Puzzle',
                        icon: Icons.abc,
                      ),
                      _buildPuzzleOption(
                        title: 'Colors Puzzle',
                        icon: Icons.palette,
                      ),
                      _buildPuzzleOption(
                        title: 'Shapes Puzzle',
                        icon: Icons.category,
                      ),
                      _buildPuzzleOption(
                        title: 'Images Puzzle',
                        icon: Icons.image,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                  onPressed: () {
                    if (selectedPuzzle == 'Numbers Puzzle') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NumberPuzzleView(size: 4),
                        ),
                      );
                    } else if (selectedPuzzle == 'Letters Puzzle') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LetterPuzzleView(),
                        ),
                      );
                    } else if (selectedPuzzle == 'Colors Puzzle') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ColorPuzzleView(),
                        ),
                      );
                    } else if (selectedPuzzle == 'Shapes Puzzle') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShapePuzzleView(),
                        ),
                      );
                    } else if (selectedPuzzle == 'Images Puzzle') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ImagePuzzleView(),
                        ),
                      );
                    }
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Comenzar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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

  Widget _buildPuzzleOption({
    required String title,
    required IconData icon,
  }) {
    bool isSelected = selectedPuzzle == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPuzzle = title;
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
              size: 45,
              color: isSelected ? Colors.deepPurple : Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.deepPurple : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}