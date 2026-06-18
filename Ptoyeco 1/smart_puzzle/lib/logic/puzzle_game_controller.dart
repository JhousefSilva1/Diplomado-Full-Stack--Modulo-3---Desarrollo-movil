import 'dart:async';

class PuzzleGameController {
  int moves = 0;
  int seconds = 0;

  bool gameFinished = false;
  bool timerStarted = false;

  Timer? _timer;

  final void Function() onUpdate;

  PuzzleGameController({
    required this.onUpdate,
  });

  void startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds++;
      onUpdate();
    });
  }

  void startTimerIfNeeded() {
    if (!timerStarted) {
      timerStarted = true;
      startTimer();
    }
  }

  void addMove() {
    moves++;
    onUpdate();
  }

  void resetGameStats() {
    moves = 0;
    seconds = 0;
    timerStarted = false;
    gameFinished = false;
    _timer?.cancel();
    onUpdate();
  }

  void finishGame() {
    gameFinished = true;
    _timer?.cancel();
    onUpdate();
  }

  String formatTime() {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    String minutesText = minutes.toString().padLeft(2, '0');
    String secondsText = remainingSeconds.toString().padLeft(2, '0');

    return '$minutesText:$secondsText';
  }

  void dispose() {
    _timer?.cancel();
  }
}