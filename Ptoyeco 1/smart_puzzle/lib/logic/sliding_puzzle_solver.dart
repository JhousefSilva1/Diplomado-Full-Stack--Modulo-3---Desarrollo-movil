// class PuzzleNode {
//   final List<int> state;
//   final List<List<int>> path;
//   final int g;
//   final int h;

//   PuzzleNode({
//     required this.state,
//     required this.path,
//     required this.g,
//     required this.h,
//   });

//   int get f => g + h;
// }

// class SlidingPuzzleSolver {
//   final int size;
//   final int emptyValue;

//   SlidingPuzzleSolver({
//     required this.size,
//     this.emptyValue = -1,
//   });

//   List<int> getGoalState() {
//     int totalPieces = size * size;

//     return List.generate(totalPieces, (index) {
//       if (index == totalPieces - 1) {
//         return emptyValue;
//       }

//       return index;
//     });
//   }

//   bool isGoal(List<int> state) {
//     List<int> goal = getGoalState();

//     for (int i = 0; i < state.length; i++) {
//       if (state[i] != goal[i]) {
//         return false;
//       }
//     }

//     return true;
//   }

//   bool canMovePiece({
//     required List<int> state,
//     required int index,
//   }) {
//     int emptyIndex = state.indexOf(emptyValue);

//     int selectedRow = index ~/ size;
//     int selectedCol = index % size;

//     int emptyRow = emptyIndex ~/ size;
//     int emptyCol = emptyIndex % size;

//     return (selectedRow == emptyRow && (selectedCol - emptyCol).abs() == 1) ||
//         (selectedCol == emptyCol && (selectedRow - emptyRow).abs() == 1);
//   }

//   List<int> movePiece({
//     required List<int> state,
//     required int index,
//   }) {
//     if (!canMovePiece(state: state, index: index)) {
//       return state;
//     }

//     List<int> newState = List.from(state);

//     int emptyIndex = newState.indexOf(emptyValue);

//     int temp = newState[index];
//     newState[index] = newState[emptyIndex];
//     newState[emptyIndex] = temp;

//     return newState;
//   }

//   List<int> shuffleByValidMoves({
//     required int moves,
//   }) {
//     List<int> state = getGoalState();

//     for (int i = 0; i < moves; i++) {
//       int emptyIndex = state.indexOf(emptyValue);

//       int emptyRow = emptyIndex ~/ size;
//       int emptyCol = emptyIndex % size;

//       List<int> possibleMoves = [];

//       if (emptyRow > 0) {
//         possibleMoves.add(emptyIndex - size);
//       }

//       if (emptyRow < size - 1) {
//         possibleMoves.add(emptyIndex + size);
//       }

//       if (emptyCol > 0) {
//         possibleMoves.add(emptyIndex - 1);
//       }

//       if (emptyCol < size - 1) {
//         possibleMoves.add(emptyIndex + 1);
//       }

//       possibleMoves.shuffle();

//       int moveIndex = possibleMoves.first;

//       int temp = state[emptyIndex];
//       state[emptyIndex] = state[moveIndex];
//       state[moveIndex] = temp;
//     }

//     return state;
//   }

//   int manhattanDistance(List<int> state) {
//     int distance = 0;

//     for (int i = 0; i < state.length; i++) {
//       int piece = state[i];

//       if (piece == emptyValue) {
//         continue;
//       }

//       int currentRow = i ~/ size;
//       int currentCol = i % size;

//       int goalIndex = piece;
//       int goalRow = goalIndex ~/ size;
//       int goalCol = goalIndex % size;

//       distance += (currentRow - goalRow).abs() + (currentCol - goalCol).abs();
//     }

//     return distance;
//   }

//   List<List<int>> getNeighbors(List<int> state) {
//     List<List<int>> neighbors = [];

//     int emptyIndex = state.indexOf(emptyValue);

//     int emptyRow = emptyIndex ~/ size;
//     int emptyCol = emptyIndex % size;

//     List<int> possibleMoves = [];

//     if (emptyRow > 0) {
//       possibleMoves.add(emptyIndex - size);
//     }

//     if (emptyRow < size - 1) {
//       possibleMoves.add(emptyIndex + size);
//     }

//     if (emptyCol > 0) {
//       possibleMoves.add(emptyIndex - 1);
//     }

//     if (emptyCol < size - 1) {
//       possibleMoves.add(emptyIndex + 1);
//     }

//     for (int moveIndex in possibleMoves) {
//       List<int> newState = List.from(state);

//       int temp = newState[emptyIndex];
//       newState[emptyIndex] = newState[moveIndex];
//       newState[moveIndex] = temp;

//       neighbors.add(newState);
//     }

//     return neighbors;
//   }

//   String stateToString(List<int> state) {
//     return state.join(',');
//   }

//   List<List<int>> solveWithAStar(List<int> start, {required List<int> state}) {
//     List<PuzzleNode> openList = [];
//     Set<String> closedList = {};

//     openList.add(
//       PuzzleNode(
//         state: start,
//         path: [start],
//         g: 0,
//         h: manhattanDistance(start),
//       ),
//     );

//     int iterations = 0;
//     int maxIterations = 20000;

//     while (openList.isNotEmpty && iterations < maxIterations) {
//       iterations++;

//       openList.sort((a, b) => a.f.compareTo(b.f));

//       PuzzleNode currentNode = openList.removeAt(0);

//       if (isGoal(currentNode.state)) {
//         return currentNode.path;
//       }

//       closedList.add(stateToString(currentNode.state));

//       List<List<int>> neighbors = getNeighbors(currentNode.state);

//       for (List<int> neighbor in neighbors) {
//         String key = stateToString(neighbor);

//         if (closedList.contains(key)) {
//           continue;
//         }

//         List<List<int>> newPath = List.from(currentNode.path);
//         newPath.add(neighbor);

//         openList.add(
//           PuzzleNode(
//             state: neighbor,
//             path: newPath,
//             g: currentNode.g + 1,
//             h: manhattanDistance(neighbor),
//           ),
//         );
//       }
//     }

//     return [];
//   }
// }