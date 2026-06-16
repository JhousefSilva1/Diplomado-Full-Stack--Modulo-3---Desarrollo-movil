import 'package:flutter/material.dart';
import 'dart:async';

class PuzzleNode {
  final List<int> state;
  final List<List<int>> path;
  final int g;
  final int h;

  PuzzleNode({
    required this.state,
    required this.path,
    required this.g,
    required this.h,
  });

  int get f => g + h;
}

class NumberPuzzleView extends StatefulWidget {
  final int size;

  const NumberPuzzleView({
    super.key,
    required this.size,
  });

  @override
  State<NumberPuzzleView> createState() => _NumberPuzzleViewState();
}

class _NumberPuzzleViewState extends State<NumberPuzzleView> {
  late List<int> pieces;
  int moves = 0;
  int seconds = 0;
  Timer? timer;
  bool gameFinished = false;
  int? lastMovedPiece;
  bool timerStarted = false;

  @override
  void initState() {
    super.initState();

    int totalPieces = widget.size * widget.size;

    pieces = List.generate(totalPieces, (index) {
      if (index == totalPieces - 1) {
        return 0;
      }
      return index + 1;
    });

    // Ya no iniciamos el reloj aquí.
    // El reloj empezará cuando se mueva la primera ficha.
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          seconds++;
        });
      }
    });
  }

  void startTimerIfNeeded() {
    if (!timerStarted) {
      timerStarted = true;
      startTimer();
    }
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
    timerStarted = false;
    timer?.cancel();
  }

  bool canMovePiece(int index) {
    int emptyIndex = pieces.indexOf(0);

    int selectedRow = index ~/ widget.size;
    int selectedCol = index % widget.size;

    int emptyRow = emptyIndex ~/ widget.size;
    int emptyCol = emptyIndex % widget.size;

    return (selectedRow == emptyRow && (selectedCol - emptyCol).abs() == 1) ||
        (selectedCol == emptyCol && (selectedRow - emptyRow).abs() == 1);
  }

  void movePiece(int index) {
    if (gameFinished) {
      return;
    }

    int emptyIndex = pieces.indexOf(0);

    if (canMovePiece(index)) {
      startTimerIfNeeded();

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

      int totalPieces = widget.size * widget.size;

      pieces = List.generate(totalPieces, (index) {
        if (index == totalPieces - 1) {
          return 0;
        }
        return index + 1;
      });

      int shuffleMoves = widget.size == 4 ? 80 : 120;

      for (int i = 0; i < shuffleMoves; i++) {
        int emptyIndex = pieces.indexOf(0);

        int emptyRow = emptyIndex ~/ widget.size;
        int emptyCol = emptyIndex % widget.size;

        List<int> possibleMoves = [];

        if (emptyRow > 0) {
          possibleMoves.add(emptyIndex - widget.size);
        }

        if (emptyRow < widget.size - 1) {
          possibleMoves.add(emptyIndex + widget.size);
        }

        if (emptyCol > 0) {
          possibleMoves.add(emptyIndex - 1);
        }

        if (emptyCol < widget.size - 1) {
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

  String stateToString(List<int> state) {
    return state.join(',');
  }

  List<int> getGoalState() {
    int totalPieces = widget.size * widget.size;

    return List.generate(totalPieces, (index) {
      if (index == totalPieces - 1) {
        return 0;
      }
      return index + 1;
    });
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

      if (piece == 0) {
        continue;
      }

      int currentRow = i ~/ widget.size;
      int currentCol = i % widget.size;

      int goalIndex = piece - 1;
      int goalRow = goalIndex ~/ widget.size;
      int goalCol = goalIndex % widget.size;

      distance +=
          (currentRow - goalRow).abs() + (currentCol - goalCol).abs();
    }

    return distance;
  }

  List<List<int>> getNeighbors(List<int> state) {
    List<List<int>> neighbors = [];

    int emptyIndex = state.indexOf(0);

    int emptyRow = emptyIndex ~/ widget.size;
    int emptyCol = emptyIndex % widget.size;

    List<int> possibleMoves = [];

    if (emptyRow > 0) {
      possibleMoves.add(emptyIndex - widget.size);
    }

    if (emptyRow < widget.size - 1) {
      possibleMoves.add(emptyIndex + widget.size);
    }

    if (emptyCol > 0) {
      possibleMoves.add(emptyIndex - 1);
    }

    if (emptyCol < widget.size - 1) {
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

    List<PuzzleNode> openList = [];
    Set<String> closedList = {};

    openList.add(
      PuzzleNode(
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

      PuzzleNode currentNode = openList.removeAt(0);

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
          PuzzleNode(
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

      if (!mounted) {
        return;
      }

      setState(() {
        pieces = List.from(solution[i]);
        moves++;
      });
    }

    checkIfGameFinished();
  }

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
            decoration: BoxDecoration(
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
            ),
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
            decoration: BoxDecoration(
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
            ),
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

  Widget buildMiniBoard(List<int> state) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        itemCount: state.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.size,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemBuilder: (context, index) {
          int piece = state[index];

          if (piece == 0) {
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
                piece.toString(),
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: widget.size == 5 ? 13 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void checkIfGameFinished() {
    if (isGoal(pieces) && !gameFinished) {
      gameFinished = true;
      timer?.cancel();

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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4A148C),
                    Color(0xFF7B1FA2),
                    Color(0xFFBA68C8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
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
                  ),
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
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.timer,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                formatTime(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Tiempo',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.touch_app,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                moves.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Movimientos',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
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
  }

  void showStepByStepSolutionDialog() {
    List<List<int>> solution = solveWithAStar();

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
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
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
                ),
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
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Anterior'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.deepPurple,
                              disabledBackgroundColor:
                                  Colors.white.withValues(alpha: 0.30),
                              disabledForegroundColor:
                                  Colors.white.withValues(alpha: 0.60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
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
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Siguiente'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.deepPurple,
                              disabledBackgroundColor:
                                  Colors.white.withValues(alpha: 0.30),
                              disabledForegroundColor:
                                  Colors.white.withValues(alpha: 0.60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Row(
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
                        'Numbers Puzzle ${widget.size}x${widget.size}',
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
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.timer,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              formatTime(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Tiempo',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.touch_app,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              moves.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Movimientos',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                AspectRatio(
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
                      int piece = pieces[index];

                      if (piece == 0) {
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
                            decoration: BoxDecoration(
                              color: isMovable
                                  ? Colors.amber.withValues(alpha: 0.95)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isMovable
                                    ? Colors.white
                                    : Colors.transparent,
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
                            ),
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
                                  piece.toString(),
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: widget.size == 5 ? 22 : 28,
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
                ),

                const SizedBox(height: 30),

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
                            showNoSolutionDialog();
                            return;
                          }

                          setState(() {
                            resetGameStats();
                            timerStarted = true;
                          });

                          startTimer();

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
            ),
          ),
        ),
      ),
    );
  }
}