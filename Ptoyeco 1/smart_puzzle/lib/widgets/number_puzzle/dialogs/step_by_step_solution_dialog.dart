import 'package:flutter/material.dart';
import 'package:smart_puzzle/widgets/number_puzzle/number_mini_puzzle_board.dart';

class StepByStepSolutionDialog extends StatefulWidget {
  final int size;
  final List<List<int>> solution;

  const StepByStepSolutionDialog({
    super.key,
    required this.size,
    required this.solution,
  });

  @override
  State<StepByStepSolutionDialog> createState() =>
      _StepByStepSolutionDialogState();
}

class _StepByStepSolutionDialogState extends State<StepByStepSolutionDialog> {
  int currentPage = 0;
  final PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    double boardSize = screenSize.width * 0.72;

    if (widget.size >= 5) {
      boardSize = screenSize.width * 0.68;
    }

    if (boardSize > 280) {
      boardSize = 280;
    }

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: screenSize.height * 0.92,
        ),
        padding: const EdgeInsets.all(16),
        decoration: _dialogDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.lightbulb,
              color: Colors.amber,
              size: 40,
            ),

            const SizedBox(height: 8),

            const Text(
              'Solución encontrada',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              'Pasos necesarios: ${widget.solution.length - 1}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              currentPage == 0
                  ? 'Estado inicial'
                  : 'Paso $currentPage de ${widget.solution.length - 1}',
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: boardSize,
              height: boardSize,
              child: PageView.builder(
                controller: pageController,
                itemCount: widget.solution.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return NumberMiniPuzzleBoard(
                    size: widget.size,
                    state: widget.solution[index],
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: currentPage == 0
                        ? null
                        : () {
                            pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 18,
                    ),
                    label: const Text(
                      'Anterior',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: _dialogButtonStyle(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: currentPage == widget.solution.length - 1
                        ? null
                        : () {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                    icon: const Icon(
                      Icons.arrow_forward,
                      size: 18,
                    ),
                    label: const Text(
                      'Siguiente',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: _dialogButtonStyle(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.deepPurple,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              height: 42,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cerrar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _dialogDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      gradient: const LinearGradient(
        colors: [
          Color(0xFF4A148C),
          Color(0xFF7B1FA2),
          Color(0xFFBA68C8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  ButtonStyle _dialogButtonStyle({
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      disabledBackgroundColor: Colors.white.withValues(alpha: 0.30),
      disabledForegroundColor: Colors.white.withValues(alpha: 0.60),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}