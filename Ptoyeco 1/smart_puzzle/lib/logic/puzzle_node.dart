class PuzzleNode<T> {
  final List<T> state;
  final List<List<T>> path;
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