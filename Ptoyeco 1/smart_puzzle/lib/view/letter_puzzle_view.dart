import 'package:flutter/material.dart';

import 'package:smart_puzzle/logic/puzzle_game_controller.dart';
import 'package:smart_puzzle/logic/sliding_puzzle_logic.dart';
import 'package:smart_puzzle/widgets/letter_puzzle/dialogs/letter_final_solution_dialog.dart';
import 'package:smart_puzzle/widgets/letter_puzzle/dialogs/letter_step_by_step_solution_dialog.dart';
import 'package:smart_puzzle/widgets/letter_puzzle/letter_puzzle_board.dart' show LetterPuzzleBoard;
import 'package:smart_puzzle/widgets/number_puzzle/dialogs/game_finished_dialog.dart';
import 'package:smart_puzzle/widgets/number_puzzle/dialogs/no_solution_dialog.dart';
import 'package:smart_puzzle/widgets/number_puzzle/puzzle_game_button.dart';
import 'package:smart_puzzle/widgets/number_puzzle/puzzle_header.dart';

import '../widgets/number_puzzle/puzzle_stats.dart' show PuzzleStats;

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

  bool canMovePiece(int index) {
    return puzzleLogic.canMovePiece(
      pieces: pieces,
      index: index,
    );
  }

  bool isGoal(List<String> state) {
    return puzzleLogic.isGoal(state);
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

  void showNoSolutionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return NoSolutionDialog(
          onShuffleAgain: shuffleByValidMoves,
        );
      },
    );
  }

  void showFinalSolutionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return LetterFinalSolutionDialog(
          size: widget.size,
          goalState: getGoalState(),
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

    showDialog(
      context: context,
      builder: (context) {
        return LetterStepByStepSolutionDialog(
          size: widget.size,
          solution: solution,
        );
      },
    );
  }

  void showGameFinishedDialog() {
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

  void checkIfGameFinished() {
    if (isGoal(pieces) && !gameController.gameFinished) {
      gameController.finishGame();
      showGameFinishedDialog();
    }
  }

  Future<void> resolveWithAStar() async {
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
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PuzzleGameButton(
                text: 'Mezclar',
                icon: Icons.shuffle,
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                onPressed: shuffleByValidMoves,
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
                  await resolveWithAStar();
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
                onPressed: showStepByStepSolutionDialog,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PuzzleGameButton(
                text: 'Solución',
                icon: Icons.check_circle,
                backgroundColor: Colors.white.withValues(alpha: 0.90),
                foregroundColor: Colors.deepPurple,
                onPressed: showFinalSolutionDialog,
              ),
            ),
          ],
        ),
      ],
    );
  }

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
                PuzzleHeader(
                  title: 'Letters Puzzle ${widget.size}x${widget.size}',
                ),
                const SizedBox(height: 50),
                PuzzleStats(
                  time: gameController.formatTime(),
                  moves: gameController.moves.toString(),
                ),
                const SizedBox(height: 30),
                LetterPuzzleBoard(
                  size: widget.size,
                  pieces: pieces,
                  lastMovedPiece: lastMovedPiece,
                  canMovePiece: canMovePiece,
                  onPieceTap: movePiece,
                ),
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