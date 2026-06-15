import 'package:flutter/material.dart';

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
  }

  void movePiece(int index) {
    int emptyIndex = pieces.indexOf(0);

    int selectedRow = index ~/ widget.size;
    int selectedCol = index % widget.size;

    int emptyRow = emptyIndex ~/ widget.size;
    int emptyCol = emptyIndex % widget.size;

    bool isNextToEmpty =
        (selectedRow == emptyRow && (selectedCol - emptyCol).abs() == 1) ||
        (selectedCol == emptyCol && (selectedRow - emptyRow).abs() == 1);

    if (isNextToEmpty) {
      setState(() {
        int temp = pieces[index];
        pieces[index] = pieces[emptyIndex];
        pieces[emptyIndex] = temp;
      });
    }
  }

void shuffleByValidMoves() {
  setState(() {
    int totalPieces = widget.size * widget.size;

    pieces = List.generate(totalPieces, (index) {
      if (index == totalPieces - 1) {
        return 0;
      }
      return index + 1;
    });

    int moves = widget.size == 4 ? 80 : 120;

    for (int i = 0; i < moves; i++) {
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

    distance += (currentRow - goalRow).abs() + (currentCol - goalCol).abs();
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
  for (List<int> step in solution) {
    await Future.delayed(const Duration(milliseconds: 400));

    setState(() {
      pieces = List.from(step);
    });
  }
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

                      return GestureDetector(
                        onTap: () {
                          movePiece(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
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
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      shuffleByValidMoves();
                    },
                    icon: const Icon(Icons.shuffle),
                    label: const Text(
                      'Mezclar',
                      style: TextStyle(
                        fontSize: 18,
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

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
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
                    icon: const Icon(Icons.psychology),
                    label: const Text(
                      'Resolver con A*',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.deepPurple,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}