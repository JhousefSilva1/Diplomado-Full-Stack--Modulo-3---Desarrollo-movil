import 'puzzle_node.dart';

class SlidingPuzzleLogic<T> {
  final int size;
  final T emptyValue;
  final List<T> goalState;

  SlidingPuzzleLogic({
    required this.size,
    required this.emptyValue,
    required this.goalState,
  });

  String stateToString(List<T> state) {
    return state.join(',');
  }

  bool isGoal(List<T> state) {
    for (int i = 0; i < state.length; i++) {
      if (state[i] != goalState[i]) {
        return false;
      }
    }

    return true;
  }

  bool canMovePiece({
    required List<T> pieces,
    required int index,
  }) {
    int emptyIndex = pieces.indexOf(emptyValue);

    int selectedRow = index ~/ size;
    int selectedCol = index % size;

    int emptyRow = emptyIndex ~/ size;
    int emptyCol = emptyIndex % size;

    return (selectedRow == emptyRow && (selectedCol - emptyCol).abs() == 1) ||
        (selectedCol == emptyCol && (selectedRow - emptyRow).abs() == 1);
  }

  List<T> movePiece({
    required List<T> pieces,
    required int index,
  }) {
    List<T> newPieces = List.from(pieces);

    int emptyIndex = newPieces.indexOf(emptyValue);

    T temp = newPieces[index];
    newPieces[index] = newPieces[emptyIndex];
    newPieces[emptyIndex] = temp;

    return newPieces;
  }

  List<T> shuffleByValidMoves({
    required int shuffleMoves,
  }) {
    List<T> pieces = List.from(goalState);

    for (int i = 0; i < shuffleMoves; i++) {
      int emptyIndex = pieces.indexOf(emptyValue);

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

      T temp = pieces[emptyIndex];
      pieces[emptyIndex] = pieces[moveIndex];
      pieces[moveIndex] = temp;
    }

    return pieces;
  }

  int manhattanDistance(List<T> state) {
    int distance = 0;

    for (int i = 0; i < state.length; i++) {
      T piece = state[i];

      if (piece == emptyValue) {
        continue;
      }

      int currentRow = i ~/ size;
      int currentCol = i % size;

      int goalIndex = goalState.indexOf(piece);
      int goalRow = goalIndex ~/ size;
      int goalCol = goalIndex % size;

      distance += (currentRow - goalRow).abs() + (currentCol - goalCol).abs();
    }

    return distance;
  }

  List<List<T>> getNeighbors(List<T> state) {
    List<List<T>> neighbors = [];

    int emptyIndex = state.indexOf(emptyValue);

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
      List<T> newState = List.from(state);

      T temp = newState[emptyIndex];
      newState[emptyIndex] = newState[moveIndex];
      newState[moveIndex] = temp;

      neighbors.add(newState);
    }

    return neighbors;
  }

  List<List<T>> solveWithAStar({
    required List<T> startState,
    int maxIterations = 20000,
  }) {
    List<PuzzleNode<T>> openList = [];
    Set<String> closedList = {};

    openList.add(
      PuzzleNode<T>(
        state: startState,
        path: [startState],
        g: 0,
        h: manhattanDistance(startState),
      ),
    );

    int iterations = 0;

    while (openList.isNotEmpty && iterations < maxIterations) {
      iterations++;

      openList.sort((a, b) => a.f.compareTo(b.f));

      PuzzleNode<T> currentNode = openList.removeAt(0);

      if (isGoal(currentNode.state)) {
        return currentNode.path;
      }

      closedList.add(stateToString(currentNode.state));

      List<List<T>> neighbors = getNeighbors(currentNode.state);

      for (List<T> neighbor in neighbors) {
        String key = stateToString(neighbor);

        if (closedList.contains(key)) {
          continue;
        }

        List<List<T>> newPath = List.from(currentNode.path);
        newPath.add(neighbor);

        openList.add(
          PuzzleNode<T>(
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
}