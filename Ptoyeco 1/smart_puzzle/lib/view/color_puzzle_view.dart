import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ColorPuzzlePiece {
  final String name;
  final Color color;

  const ColorPuzzlePiece({
    required this.name,
    required this.color,
  });
}

class ColorPuzzleNode {
  final List<int> state;
  final List<List<int>> path;
  final int g;
  final int h;

  ColorPuzzleNode({
    required this.state,
    required this.path,
    required this.g,
    required this.h,
  });

  int get f => g + h;
}

class ColorPuzzleView extends StatefulWidget {
  const ColorPuzzleView({super.key});

  @override
  State<ColorPuzzleView> createState() => _ColorPuzzleViewState();
}

class _ColorPuzzleViewState extends State<ColorPuzzleView> {
  // =========================
  // VARIABLES
  // =========================

  final int size = 3;

  late List<ColorPuzzlePiece> currentGoalColors;
  late List<int> pieces;

  int moves = 0;
  int seconds = 0;

  Timer? timer;

  bool gameFinished = false;
  int? lastMovedPiece;

final List<List<ColorPuzzlePiece>> puzzleGoals = const [
  [
    ColorPuzzlePiece(name: 'Rojo', color: Color(0xFFE53935)),
    ColorPuzzlePiece(name: 'Amarillo', color: Color(0xFFFFD600)),
    ColorPuzzlePiece(name: 'Verde', color: Color(0xFF43A047)),
    ColorPuzzlePiece(name: 'Azul', color: Color(0xFF1E88E5)),
    ColorPuzzlePiece(name: 'Negro', color: Color(0xFF212121)),
    ColorPuzzlePiece(name: 'Celeste', color: Color(0xFF00B8D4)),
    ColorPuzzlePiece(name: 'Naranja', color: Color(0xFFFF8F00)),
    ColorPuzzlePiece(name: 'Blanco', color: Color(0xFFF5F5F5)),
  ],
  [
    ColorPuzzlePiece(name: 'Azul', color: Color(0xFF1E88E5)),
    ColorPuzzlePiece(name: 'Amarillo', color: Color(0xFFFFD600)),
    ColorPuzzlePiece(name: 'Rojo', color: Color(0xFFE53935)),
    ColorPuzzlePiece(name: 'Celeste', color: Color(0xFF00B8D4)),
    ColorPuzzlePiece(name: 'Verde', color: Color(0xFF43A047)),
    ColorPuzzlePiece(name: 'Naranja', color: Color(0xFFFF8F00)),
    ColorPuzzlePiece(name: 'Blanco', color: Color(0xFFF5F5F5)),
    ColorPuzzlePiece(name: 'Negro', color: Color(0xFF212121)),
  ],
  [
    ColorPuzzlePiece(name: 'Verde', color: Color(0xFF43A047)),
    ColorPuzzlePiece(name: 'Rojo', color: Color(0xFFE53935)),
    ColorPuzzlePiece(name: 'Naranja', color: Color(0xFFFF8F00)),
    ColorPuzzlePiece(name: 'Azul', color: Color(0xFF1E88E5)),
    ColorPuzzlePiece(name: 'Negro', color: Color(0xFF212121)),
    ColorPuzzlePiece(name: 'Amarillo', color: Color(0xFFFFD600)),
    ColorPuzzlePiece(name: 'Blanco', color: Color(0xFFF5F5F5)),
    ColorPuzzlePiece(name: 'Celeste', color: Color(0xFF00B8D4)),
  ],
  [
    ColorPuzzlePiece(name: 'Negro', color: Color(0xFF212121)),
    ColorPuzzlePiece(name: 'Celeste', color: Color(0xFF00B8D4)),
    ColorPuzzlePiece(name: 'Azul', color: Color(0xFF1E88E5)),
    ColorPuzzlePiece(name: 'Amarillo', color: Color(0xFFFFD600)),
    ColorPuzzlePiece(name: 'Naranja', color: Color(0xFFFF8F00)),
    ColorPuzzlePiece(name: 'Rojo', color: Color(0xFFE53935)),
    ColorPuzzlePiece(name: 'Blanco', color: Color(0xFFF5F5F5)),
    ColorPuzzlePiece(name: 'Verde', color: Color(0xFF43A047)),
  ],
];
  // =========================
  // CICLO DE VIDA
  // =========================

  @override
  void initState() {
    super.initState();

    selectRandomGoalColors();
    pieces = getGoalState();

    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // =========================
  // LÓGICA DEL JUEGO
  // =========================

  void selectRandomGoalColors() {
    int randomIndex = Random().nextInt(puzzleGoals.length);
    currentGoalColors = puzzleGoals[randomIndex];
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });
  }

  String formatTime() {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    String minutesText = minutes.toString().padLeft(2, '0');
    String secondsText = remainingSeconds.toString().padLeft(2, '0');

    return '$minutesText:$secondsText';
  }

  void resetGameStats() {
    moves = 0;
    seconds = 0;
  }

  bool canMovePiece(int index) {
    int emptyIndex = pieces.indexOf(-1);

    int selectedRow = index ~/ size;
    int selectedCol = index % size;

    int emptyRow = emptyIndex ~/ size;
    int emptyCol = emptyIndex % size;

    return (selectedRow == emptyRow && (selectedCol - emptyCol).abs() == 1) ||
        (selectedCol == emptyCol && (selectedRow - emptyRow).abs() == 1);
  }

  void movePiece(int index) {
    if (gameFinished) {
      return;
    }

    int emptyIndex = pieces.indexOf(-1);

    if (canMovePiece(index)) {
      setState(() {
        int temp = pieces[index];

        pieces[index] = pieces[emptyIndex];
        pieces[emptyIndex] = temp;

        lastMovedPiece = temp;
        moves++;
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
      resetGameStats();
      gameFinished = false;

      timer?.cancel();
      startTimer();

      pieces = getGoalState();

      int shuffleMoves = 80;

      for (int i = 0; i < shuffleMoves; i++) {
        int emptyIndex = pieces.indexOf(-1);

        int emptyRow = emptyIndex ~/ size;
        int emptyCol = emptyIndex % size;

        List<int> possibleMoves = [];

        if (emptyRow > 0) {
          possibleMoves.add(emptyIndex - size);
        }

        if (emptyRow < size - 1) {
          possibleMoves.add(emptyIndex + size);
        }

        if (emptyCol > 0) {
          possibleMoves.add(emptyIndex - 1);
        }

        if (emptyCol < size - 1) {
          possibleMoves.add(emptyIndex + 1);
        }

        possibleMoves.shuffle();

        int moveIndex = possibleMoves.first;

        int temp = pieces[emptyIndex];
        pieces[emptyIndex] = pieces[moveIndex];
        pieces[moveIndex] = temp;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Puzzle mezclado correctamente'),
      ),
    );
  }

  void checkIfGameFinished() {
    if (isGoal(pieces) && !gameFinished) {
      gameFinished = true;
      timer?.cancel();

      showGameFinishedDialog();
    }
  }

  // =========================
  // ALGORITMO A*
  // =========================

  String stateToString(List<int> state) {
    return state.join(',');
  }

  List<int> getGoalState() {
    return [
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      -1,
    ];
  }

  bool isGoal(List<int> state) {
    List<int> goal = getGoalState();

    for (int i = 0; i < state.length; i++) {
      if (state[i] != goal[i]) {
        return false;
      }
    }

    return true;
  }

  int manhattanDistance(List<int> state) {
    int distance = 0;

    for (int i = 0; i < state.length; i++) {
      int piece = state[i];

      if (piece == -1) {
        continue;
      }

      int currentRow = i ~/ size;
      int currentCol = i % size;

      int goalIndex = piece;
      int goalRow = goalIndex ~/ size;
      int goalCol = goalIndex % size;

      distance += (currentRow - goalRow).abs() + (currentCol - goalCol).abs();
    }

    return distance;
  }

  List<List<int>> getNeighbors(List<int> state) {
    List<List<int>> neighbors = [];

    int emptyIndex = state.indexOf(-1);

    int emptyRow = emptyIndex ~/ size;
    int emptyCol = emptyIndex % size;

    List<int> possibleMoves = [];

    if (emptyRow > 0) {
      possibleMoves.add(emptyIndex - size);
    }

    if (emptyRow < size - 1) {
      possibleMoves.add(emptyIndex + size);
    }

    if (emptyCol > 0) {
      possibleMoves.add(emptyIndex - 1);
    }

    if (emptyCol < size - 1) {
      possibleMoves.add(emptyIndex + 1);
    }

    for (int moveIndex in possibleMoves) {
      List<int> newState = List.from(state);

      int temp = newState[emptyIndex];
      newState[emptyIndex] = newState[moveIndex];
      newState[moveIndex] = temp;

      neighbors.add(newState);
    }

    return neighbors;
  }

  List<List<int>> solveWithAStar() {
    List<int> start = List.from(pieces);

    List<ColorPuzzleNode> openList = [];
    Set<String> closedList = {};

    openList.add(
      ColorPuzzleNode(
        state: start,
        path: [start],
        g: 0,
        h: manhattanDistance(start),
      ),
    );

    int iterations = 0;
    int maxIterations = 20000;

    while (openList.isNotEmpty && iterations < maxIterations) {
      iterations++;

      openList.sort((a, b) => a.f.compareTo(b.f));

      ColorPuzzleNode currentNode = openList.removeAt(0);

      if (isGoal(currentNode.state)) {
        return currentNode.path;
      }

      closedList.add(stateToString(currentNode.state));

      List<List<int>> neighbors = getNeighbors(currentNode.state);

      for (List<int> neighbor in neighbors) {
        String key = stateToString(neighbor);

        if (closedList.contains(key)) {
          continue;
        }

        List<List<int>> newPath = List.from(currentNode.path);
        newPath.add(neighbor);

        openList.add(
          ColorPuzzleNode(
            state: neighbor,
            path: newPath,
            g: currentNode.g + 1,
            h: manhattanDistance(neighbor),
          ),
        );
      }
    }

    return [];
  }

  Future<void> animateSolution(List<List<int>> solution) async {
    for (int i = 1; i < solution.length; i++) {
      await Future.delayed(const Duration(milliseconds: 400));

      setState(() {
        pieces = List.from(solution[i]);
        moves++;
      });
    }

    checkIfGameFinished();
  }

  // =========================
  // DIÁLOGOS
  // =========================

  void showFinalSolutionDialog() {
    List<int> goalState = getGoalState();

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
                  'Así debe quedar armado este puzzle',
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
    List<List<int>> solution = solveWithAStar();

    if (solution.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontró solución'),
        ),
      );

      return;
    }

    int currentPage = 0;
    PageController pageController = PageController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
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
                      Icons.lightbulb,
                      color: Colors.amber,
                      size: 48,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Solución encontrada',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Pasos necesarios: ${solution.length - 1}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      currentPage == 0
                          ? 'Estado inicial'
                          : 'Paso $currentPage de ${solution.length - 1}',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 260,
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
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: currentPage == 0
                                ? null
                                : () {
                                    pageController.previousPage(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Anterior'),
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
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Siguiente'),
                            style: _dialogButtonStyle(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cerrar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
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
                      value: formatTime(),
                      label: 'Tiempo',
                    ),
                    const SizedBox(width: 12),
                    _buildResultCard(
                      icon: Icons.touch_app,
                      value: moves.toString(),
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
        const Expanded(
          child: Text(
            'Colors Puzzle 3x3',
            textAlign: TextAlign.center,
            style: TextStyle(
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
          value: formatTime(),
          label: 'Tiempo',
        ),
        const SizedBox(width: 14),
        _buildStatCard(
          icon: Icons.touch_app,
          value: moves.toString(),
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
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          int pieceIndex = pieces[index];

          if (pieceIndex == -1) {
            return _buildEmptyPiece();
          }

          ColorPuzzlePiece piece = currentGoalColors[pieceIndex];

          bool isMovable = canMovePiece(index);
          bool isLastMoved = lastMovedPiece == pieceIndex;

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
                decoration: _pieceDecoration(
                  pieceColor: piece.color,
                  isMovable: isMovable,
                ),
                child: Center(
                  child: Text(
                    piece.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _textColorFor(piece.color),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
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

  BoxDecoration _pieceDecoration({
    required Color pieceColor,
    required bool isMovable,
  }) {
    return BoxDecoration(
      color: pieceColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isMovable ? Colors.white : Colors.transparent,
        width: isMovable ? 3 : 0,
      ),
      boxShadow: [
        BoxShadow(
          color: isMovable
              ? Colors.amber.withValues(alpha: 0.70)
              : Colors.black.withValues(alpha: 0.25),
          blurRadius: isMovable ? 16 : 6,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Color _textColorFor(Color backgroundColor) {
    double brightness = ThemeData.estimateBrightnessForColor(backgroundColor) ==
            Brightness.dark
        ? 1
        : 0;

    if (brightness == 1) {
      return Colors.white;
    }

    return Colors.black;
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
                  List<List<int>> solution = solveWithAStar();

                  if (solution.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No se encontró solución'),
                      ),
                    );

                    return;
                  }

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

  Widget buildMiniBoard(List<int> state) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        itemCount: state.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemBuilder: (context, index) {
          int pieceIndex = state[index];

          if (pieceIndex == -1) {
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

          ColorPuzzlePiece piece = currentGoalColors[pieceIndex];

          return Container(
            decoration: BoxDecoration(
              color: piece.color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                piece.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _textColorFor(piece.color),
                  fontSize: 12,
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