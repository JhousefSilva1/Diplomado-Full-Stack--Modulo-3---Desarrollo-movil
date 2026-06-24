import '../models/network_edge.dart';

class GraphAlgorithms {
  static List<int> getNeighbors({
    required int nodeId,
    required List<NetworkEdge> edges,
  }) {
    final neighbors = <int>[];

    for (final edge in edges) {
      if (edge.from == nodeId) {
        neighbors.add(edge.to);
      } else if (edge.to == nodeId) {
        neighbors.add(edge.from);
      }
    }

    return neighbors;
  }

  static bool edgeExists({
    required int from,
    required int to,
    required List<NetworkEdge> edges,
  }) {
    return edges.any(
      (edge) =>
          (edge.from == from && edge.to == to) ||
          (edge.from == to && edge.to == from),
    );
  }

  static bool hasPath({
    required int start,
    required int goal,
    required List<NetworkEdge> edges,
    required Set<int> blockedNodes,
  }) {
    if (blockedNodes.contains(start) || blockedNodes.contains(goal)) {
      return false;
    }

    final queue = <int>[start];
    final visited = <int>{start};

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);

      if (current == goal) {
        return true;
      }

      final neighbors = getNeighbors(
        nodeId: current,
        edges: edges,
      );

      for (final neighbor in neighbors) {
        if (blockedNodes.contains(neighbor)) continue;
        if (visited.contains(neighbor)) continue;

        visited.add(neighbor);
        queue.add(neighbor);
      }
    }

    return false;
  }

  static List<int> shortestPathBfs({
    required int start,
    required int goal,
    required List<NetworkEdge> edges,
    required Set<int> blockedNodes,
  }) {
    if (blockedNodes.contains(start) || blockedNodes.contains(goal)) {
      return [];
    }

    final queue = <int>[start];
    final visited = <int>{start};
    final previous = <int, int>{};

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);

      if (current == goal) {
        break;
      }

      final neighbors = getNeighbors(
        nodeId: current,
        edges: edges,
      );

      for (final neighbor in neighbors) {
        if (blockedNodes.contains(neighbor)) continue;
        if (visited.contains(neighbor)) continue;

        visited.add(neighbor);
        previous[neighbor] = current;
        queue.add(neighbor);
      }
    }

    if (!visited.contains(goal)) {
      return [];
    }

    final path = <int>[];
    int? current = goal;

    while (current != null) {
      path.insert(0, current);

      if (current == start) {
        break;
      }

      current = previous[current];
    }

    return path;
  }
}