import 'package:flutter/material.dart';
import 'package:smart_puzzle/logic/puzzle_game_controller.dart';
import 'package:smart_puzzle/logic/sliding_puzzle_logic.dart';
import 'package:smart_puzzle/widgets/number_puzzle/dialogs/final_solution_dialog.dart';
import 'package:smart_puzzle/widgets/number_puzzle/dialogs/game_finished_dialog.dart';
import 'package:smart_puzzle/widgets/number_puzzle/dialogs/no_solution_dialog.dart';
import 'package:smart_puzzle/widgets/number_puzzle/dialogs/step_by_step_solution_dialog.dart';
import 'package:smart_puzzle/widgets/number_puzzle/number_mini_puzzle_board.dart';
import 'package:smart_puzzle/widgets/number_puzzle/number_puzzle_board.dart';
import 'package:smart_puzzle/widgets/number_puzzle/puzzle_game_button.dart';
import 'package:smart_puzzle/widgets/number_puzzle/puzzle_header.dart';
import 'package:smart_puzzle/widgets/number_puzzle/puzzle_stats.dart';

class NumberPuzzleView extends StatefulWidget {
  final int size;
  const NumberPuzzleView({super.key, required this.size});

  @override
  State<NumberPuzzleView> createState() => _NumberPuzzleViewState();
}
class _NumberPuzzleViewState extends State<NumberPuzzleView> {
  late SlidingPuzzleLogic<int> puzzleLogic;
  late PuzzleGameController gameController;
  late List<int> pieces;
  int? lastMovedPiece;

  @override
  void initState() {
    super.initState();

    pieces = getGoalState();
    puzzleLogic = SlidingPuzzleLogic<int>(
      size: widget.size,
      emptyValue: 0,
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

  bool canMovePiece(int index) {
    return puzzleLogic.canMovePiece(pieces: pieces, index: index);
  }
  void movePiece(int index) {
    if (gameController.gameFinished) {
      return;
    }

    int emptyIndex = pieces.indexOf(0);

    if (canMovePiece(index)) {
      gameController.startTimerIfNeeded();

      setState(() {
        int temp = pieces[index];

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

      int shuffleMoves = widget.size <= 3 ? 60 : 120;

      pieces = puzzleLogic.shuffleByValidMoves(shuffleMoves: shuffleMoves);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Puzzle mezclado correctamente')),
    );
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
    return puzzleLogic.isGoal(state);
  }

  List<List<int>> solveWithAStar() {
    return puzzleLogic.solveWithAStar(startState: List.from(pieces));
  }

  Future<void> animateSolution(List<List<int>> solution) async {
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

  void showNoSolutionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return NoSolutionDialog(onShuffleAgain: shuffleByValidMoves);
      },
    );
  }

  void showFinalSolutionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return FinalSolutionDialog(
          size: widget.size,
          goalState: getGoalState(),
        );
      },
    );
  }

  Widget buildMiniBoard(List<int> state) {
    return NumberMiniPuzzleBoard(size: widget.size, state: state);
  }

void checkIfGameFinished() {
  if (isGoal(pieces) && !gameController.gameFinished) {
    gameController.finishGame();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return GameFinishedDialog(
          time: gameController.formatTime(),
          moves: gameController.moves.toString(),
          onPlayAgain: shuffleByValidMoves,
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

    showDialog(
      context: context,
      builder: (context) {
        return StepByStepSolutionDialog(size: widget.size, solution: solution);
      },
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
            colors: [Color(0xFF4A148C), Color(0xFF7B1FA2), Color(0xFFBA68C8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                PuzzleHeader(
                  title: 'Numbers Puzzle ${widget.size}x${widget.size}',
                ),

                const SizedBox(height: 30),

                PuzzleStats(
                  time: gameController.formatTime(),
                  moves: gameController.moves.toString(),
                ),

                const SizedBox(height: 30),

                NumberPuzzleBoard(
                  size: widget.size,
                  pieces: pieces,
                  lastMovedPiece: lastMovedPiece,
                  canMovePiece: canMovePiece,
                  onPieceTap: movePiece,
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: PuzzleGameButton(
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
                      child: PuzzleGameButton(
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
                      child: PuzzleGameButton(
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
                      child: PuzzleGameButton(
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
