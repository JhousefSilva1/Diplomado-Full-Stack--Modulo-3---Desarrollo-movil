import 'package:flutter/material.dart';
import 'package:smart_puzzle/logic/puzzle_game_controller.dart';

import 'package:smart_puzzle/logic/sliding_puzzle_logic.dart';


class LetterPuzzleView extends StatefulWidget {
  final int size;

  const LetterPuzzleView({
    super.key,
    required this.size,
  });

  @override
  State<LetterPuzzleView> createState() => _LetterPuzzleViewState();
}

class _LetterPuzzleViewState extends State<LetterPuzzleView> {

late SlidingPuzzleLogic<String> puzzleLogic;
late PuzzleGameController gameController;
late List<String> pieces;
String? lastMovedPiece;

  // =========================
  // CICLO DE VIDA
  // =========================

@override
void initState() {
  super.initState();

  pieces = getGoalState();

  puzzleLogic = SlidingPuzzleLogic<String>(
    size: widget.size,
    emptyValue: '',
    goalState: getGoalState(),
  );

  gameController = PuzzleGameController(
    onUpdate: () {
      if (mounted) {
        setState(() {});
      }
    },
  );
}
@override
void dispose() {
  gameController.dispose();
  super.dispose();
}

  // =========================
  // LÓGICA DEL RELOJ
  // =========================

  // =========================
  // LÓGICA DEL JUEGO
  // =========================

  bool canMovePiece(int index) {
    return puzzleLogic.canMovePiece(
      pieces: pieces,
      index: index,
    );
  }

void movePiece(int index) {
  if (gameController.gameFinished) {
    return;
  }

  int emptyIndex = pieces.indexOf('');

  if (canMovePiece(index)) {
    gameController.startTimerIfNeeded();

    setState(() {
      String temp = pieces[index];

      pieces[index] = pieces[emptyIndex];
      pieces[emptyIndex] = temp;

      lastMovedPiece = temp;
      gameController.addMove();
    });

    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) {
        setState(() {
          lastMovedPiece = null;
        });
      }
    });

    checkIfGameFinished();
  }
}

void shuffleByValidMoves() {
  setState(() {
    gameController.resetGameStats();

    int shuffleMoves = widget.size <= 3 ? 60 : 80;

    pieces = puzzleLogic.shuffleByValidMoves(
      shuffleMoves: shuffleMoves,
    );
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Puzzle mezclado correctamente'),
    ),
  );
}

void checkIfGameFinished() {
  if (isGoal(pieces) && !gameController.gameFinished) {
    gameController.finishGame();

    showGameFinishedDialog();
  }
}

  // =========================
  // ALGORITMO A*
  // =========================

  // String stateToString(List<String> state) {
  //   return state.join(',');
  // }

  List<String> getGoalState() {
    List<String> letters = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z',
      'Ä',
      'Ö',
      'Ü',
      'ß',
      'Ñ',
      'LL',
      'RR',
      'CH',
      '@',
      '#',
      '',
    ];

    int totalPieces = widget.size * widget.size;

    List<String> goal = [];

    for (int i = 0; i < totalPieces - 1; i++) {
      goal.add(letters[i]);
    }

    goal.add('');

    return goal;
  }

  bool isGoal(List<String> state) {
    return puzzleLogic.isGoal(state);
  }

  // int manhattanDistance(List<String> state) {
  //   int distance = 0;

  //   List<String> goal = getGoalState();

  //   for (int i = 0; i < state.length; i++) {
  //     String piece = state[i];

  //     if (piece == '') {
  //       continue;
  //     }

  //     int currentRow = i ~/ widget.size;
  //     int currentCol = i % widget.size;

  //     int goalIndex = goal.indexOf(piece);
  //     int goalRow = goalIndex ~/ widget.size;
  //     int goalCol = goalIndex % widget.size;

  //     distance += (currentRow - goalRow).abs() + (currentCol - goalCol).abs();
  //   }

  //   return distance;
  // }

  // List<List<String>> getNeighbors(List<String> state) {
  //   List<List<String>> neighbors = [];

  //   int emptyIndex = state.indexOf('');

  //   int emptyRow = emptyIndex ~/ widget.size;
  //   int emptyCol = emptyIndex % widget.size;

  //   List<int> possibleMoves = [];

  //   if (emptyRow > 0) {
  //     possibleMoves.add(emptyIndex - widget.size);
  //   }

  //   if (emptyRow < widget.size - 1) {
  //     possibleMoves.add(emptyIndex + widget.size);
  //   }

  //   if (emptyCol > 0) {
  //     possibleMoves.add(emptyIndex - 1);
  //   }

  //   if (emptyCol < widget.size - 1) {
  //     possibleMoves.add(emptyIndex + 1);
  //   }

  //   for (int moveIndex in possibleMoves) {
  //     List<String> newState = List.from(state);

  //     String temp = newState[emptyIndex];
  //     newState[emptyIndex] = newState[moveIndex];
  //     newState[moveIndex] = temp;

  //     neighbors.add(newState);
  //   }

  //   return neighbors;
  // }

List<List<String>> solveWithAStar() {
  return puzzleLogic.solveWithAStar(
    startState: List.from(pieces),
  );
}

  Future<void> animateSolution(List<List<String>> solution) async {
    for (int i = 1; i < solution.length; i++) {
      await Future.delayed(const Duration(milliseconds: 400));

      if (!mounted) {
        return;
      }

      setState(() {
        pieces = List.from(solution[i]);
        gameController.addMove();
      });
    }

    checkIfGameFinished();
  }

  // =========================
  // DIÁLOGOS
  // =========================

  void showNoSolutionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: _dialogDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.redAccent,
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'No hay solución',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'El algoritmo A* no encontró una forma de resolver este estado del puzzle.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                    label: const Text(
                      'Cerrar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    shuffleByValidMoves();
                  },
                  icon: const Icon(
                    Icons.shuffle,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Mezclar otra vez',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showFinalSolutionDialog() {
    List<String> goalState = getGoalState();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: _dialogDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.amber,
                  size: 52,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Solución final',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Así debe quedar armado el puzzle',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 260,
                  child: buildMiniBoard(goalState),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Entendido',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

void showStepByStepSolutionDialog() {
  List<List<String>> solution = solveWithAStar();

  if (solution.isEmpty) {
    showNoSolutionDialog();
    return;
  }

  int currentPage = 0;
  PageController pageController = PageController();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
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
                    'Pasos necesarios: ${solution.length - 1}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    currentPage == 0
                        ? 'Estado inicial'
                        : 'Paso $currentPage de ${solution.length - 1}',
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
                      itemCount: solution.length,
                      onPageChanged: (index) {
                        setDialogState(() {
                          currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return buildMiniBoard(solution[index]);
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
                          icon: const Icon(Icons.arrow_back, size: 18),
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
                          onPressed: currentPage == solution.length - 1
                              ? null
                              : () {
                                  pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                          icon: const Icon(Icons.arrow_forward, size: 18),
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
        },
      );
    },
  );
}

  void showGameFinishedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: _dialogDecoration(
              borderRadius: 28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildWinnerIcon(),
                const SizedBox(height: 20),
                const Text(
                  '¡Puzzle completado!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Excelente trabajo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _buildResultCard(
                      icon: Icons.timer,
                      value: gameController.formatTime(),
                      label: 'Tiempo',
                    ),
                    const SizedBox(width: 12),
                    _buildResultCard(
                      icon: Icons.touch_app,
                      value: gameController.moves.toString(),
                      label: 'Movimientos',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      shuffleByValidMoves();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      'Jugar otra vez',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Volver al menú',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================
  // WIDGETS AUXILIARES
  // =========================

  BoxDecoration _screenDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
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

  BoxDecoration _dialogDecoration({
    double borderRadius = 24,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
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

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        Expanded(
          child: Text(
            'Letters Puzzle ${widget.size}x${widget.size}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.timer,
          value: gameController.formatTime(),
          label: 'Tiempo',
        ),
        const SizedBox(width: 14),
        _buildStatCard(
          icon: Icons.touch_app,
          value: gameController.moves.toString(),
          label: 'Movimientos',
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoard() {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        itemCount: pieces.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.size,
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
              movePiece(index);
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
                        fontSize: widget.size >= 5 ? 22 : 32,
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

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildGameButton(
                text: 'Mezclar',
                icon: Icons.shuffle,
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                onPressed: () {
                  shuffleByValidMoves();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGameButton(
                text: 'Resolver A*',
                icon: Icons.psychology,
                backgroundColor: Colors.amber,
                foregroundColor: Colors.deepPurple,
                onPressed: () async {
                  List<List<String>> solution = solveWithAStar();

                  if (solution.isEmpty) {
                    showNoSolutionDialog();
                    return;
                  }

                setState(() {
                  gameController.resetGameStats();
                  gameController.timerStarted = true;
                });

                gameController.startTimer();

                await animateSolution(solution);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildGameButton(
                text: 'Paso a paso',
                icon: Icons.visibility,
                backgroundColor: Colors.white.withValues(alpha: 0.90),
                foregroundColor: Colors.deepPurple,
                onPressed: () {
                  showStepByStepSolutionDialog();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGameButton(
                text: 'Solución',
                icon: Icons.check_circle,
                backgroundColor: Colors.white.withValues(alpha: 0.90),
                foregroundColor: Colors.deepPurple,
                onPressed: () {
                  showFinalSolutionDialog();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGameButton({
    required String text,
    required IconData icon,
    required Color backgroundColor,
    required Color foregroundColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget buildMiniBoard(List<String> state) {
    double fontSize = 22;

    if (widget.size == 4) {
      fontSize = 20;
    } else if (widget.size == 5) {
      fontSize = 15;
    } else if (widget.size >= 6) {
      fontSize = 12;
    }

    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        itemCount: state.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.size,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemBuilder: (context, index) {
          String piece = state[index];

          if (piece == '') {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.30),
                ),
              ),
            );
          }

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
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

  Widget _buildWinnerIcon() {
    return Container(
      width: 86,
      height: 86,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.amber,
          width: 3,
        ),
      ),
      child: const Icon(
        Icons.emoji_events,
        color: Colors.amber,
        size: 52,
      ),
    );
  }

  Widget _buildResultCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // BUILD PRINCIPAL
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _screenDecoration(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 50),
                _buildStats(),
                const SizedBox(height: 30),
                _buildBoard(),
                const SizedBox(height: 48),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}