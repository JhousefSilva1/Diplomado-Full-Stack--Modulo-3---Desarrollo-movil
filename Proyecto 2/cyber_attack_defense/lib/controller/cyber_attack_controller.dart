import 'dart:async';

import 'package:flutter/material.dart';

import '../core/enums/editor_mode.dart';
import '../core/enums/node_status.dart';
import '../logic/graph_algorithms.dart';
import '../models/network_edge.dart';
import '../models/network_node.dart';
import '../core/enums/device_type.dart';

class SimulationResult {
  final String title;
  final String message;
  final bool success;

  SimulationResult({
    required this.title,
    required this.message,
    required this.success,
  });
}

class CyberAttackController extends ChangeNotifier {
  final List<NetworkNode> nodes = [];
  final List<NetworkEdge> edges = [];

  EditorMode currentMode = EditorMode.addNode;
  DeviceType selectedDeviceType = DeviceType.computer;

  int _nextNodeId = 1;
  int? selectedNodeId;
  bool isSimulating = false;

  static const double nodeRadius = 25;

  void changeDeviceType(DeviceType type) {
    selectedDeviceType = type;
    notifyListeners();
  }

  void changeMode(EditorMode mode) {
    currentMode = mode;
    selectedNodeId = null;
    notifyListeners();
  }

  void handleTap(Offset position) {
    if (isSimulating) return;

    switch (currentMode) {
      case EditorMode.addNode:
        addNode(position);
        break;

      case EditorMode.connect:
        connectNode(position);
        break;

      case EditorMode.server:
        setServer(position);
        break;

      case EditorMode.virus:
        setVirus(position);
        break;

      case EditorMode.firewall:
        setFirewall(position);
        break;

      case EditorMode.erase:
        eraseNode(position);
        break;
    }
  }

  void addNode(Offset position) {
    final touchedNode = findNodeAtPosition(position);

    if (touchedNode != null) {
      return;
    }

    nodes.add(
      NetworkNode(
        id: _nextNodeId,
        position: position,
        deviceType: selectedDeviceType,
      ),
    );

    _nextNodeId++;
    notifyListeners();
  }

  void connectNode(Offset position) {
    final touchedNode = findNodeAtPosition(position);

    if (touchedNode == null) return;

    if (selectedNodeId == null) {
      selectedNodeId = touchedNode.id;
      notifyListeners();
      return;
    }

    if (selectedNodeId == touchedNode.id) {
      selectedNodeId = null;
      notifyListeners();
      return;
    }

    final alreadyExists = GraphAlgorithms.edgeExists(
      from: selectedNodeId!,
      to: touchedNode.id,
      edges: edges,
    );

    if (!alreadyExists) {
      edges.add(
        NetworkEdge(
          from: selectedNodeId!,
          to: touchedNode.id,
        ),
      );
    }

    selectedNodeId = null;
    notifyListeners();
  }

  void setServer(Offset position) {
    final touchedNode = findNodeAtPosition(position);

    if (touchedNode == null) return;

    for (final node in nodes) {
      if (node.status == NodeStatus.server) {
        node.status = NodeStatus.normal;
      }
    }

    touchedNode.status = NodeStatus.server;
    notifyListeners();
  }

  void setVirus(Offset position) {
    final touchedNode = findNodeAtPosition(position);

    if (touchedNode == null) return;
    if (touchedNode.status == NodeStatus.server) return;
    if (touchedNode.status == NodeStatus.firewall) return;

    for (final node in nodes) {
      if (node.status == NodeStatus.infected) {
        node.status = NodeStatus.normal;
      }
    }

    touchedNode.status = NodeStatus.infected;
    notifyListeners();
  }

  void setFirewall(Offset position) {
    final touchedNode = findNodeAtPosition(position);

    if (touchedNode == null) return;
    if (touchedNode.status == NodeStatus.server) return;
    if (touchedNode.status == NodeStatus.infected) return;

    if (touchedNode.status == NodeStatus.firewall) {
      touchedNode.status = NodeStatus.normal;
    } else {
      touchedNode.status = NodeStatus.firewall;
    }

    notifyListeners();
  }

  void eraseNode(Offset position) {
    final touchedNode = findNodeAtPosition(position);

    if (touchedNode == null) return;

    nodes.removeWhere((node) => node.id == touchedNode.id);

    edges.removeWhere(
      (edge) => edge.from == touchedNode.id || edge.to == touchedNode.id,
    );

    if (selectedNodeId == touchedNode.id) {
      selectedNodeId = null;
    }

    notifyListeners();
  }

  NetworkNode? findNodeAtPosition(Offset position) {
    for (final node in nodes.reversed) {
      final distance = (node.position - position).distance;

      if (distance <= nodeRadius + 10) {
        return node;
      }
    }

    return null;
  }

  NetworkNode? getNodeById(int id) {
    try {
      return nodes.firstWhere((node) => node.id == id);
    } catch (_) {
      return null;
    }
  }

  NetworkNode? getServerNode() {
    try {
      return nodes.firstWhere((node) => node.status == NodeStatus.server);
    } catch (_) {
      return null;
    }
  }

  List<int> getNeighbors(int nodeId) {
    return GraphAlgorithms.getNeighbors(
      nodeId: nodeId,
      edges: edges,
    );
  }

  Future<SimulationResult> simulateAttack() async {
    final serverNode = getServerNode();

    final infectedNodes = nodes
        .where((node) => node.status == NodeStatus.infected)
        .map((node) => node.id)
        .toSet();

    if (nodes.length < 2) {
      return SimulationResult(
        title: 'Red incompleta',
        message: 'Crea varios nodos antes de simular el ataque.',
        success: false,
      );
    }

    if (edges.isEmpty) {
      return SimulationResult(
        title: 'Sin conexiones',
        message: 'Conecta los nodos con cables antes de iniciar el ataque.',
        success: false,
      );
    }

    if (serverNode == null) {
      return SimulationResult(
        title: 'Falta servidor',
        message: 'Selecciona un nodo como servidor principal.',
        success: false,
      );
    }

    if (infectedNodes.isEmpty) {
      return SimulationResult(
        title: 'Falta virus',
        message: 'Selecciona un nodo infectado para iniciar el ataque.',
        success: false,
      );
    }

    isSimulating = true;
    selectedNodeId = null;
    notifyListeners();

    final visited = <int>{...infectedNodes};
    var frontier = <int>[...infectedNodes];

    bool serverInfected = false;

    while (frontier.isNotEmpty && !serverInfected) {
      await Future.delayed(const Duration(milliseconds: 750));

      final nextFrontier = <int>[];

      for (final currentId in frontier) {
        final neighbors = getNeighbors(currentId);

        for (final neighborId in neighbors) {
          final neighborNode = getNodeById(neighborId);

          if (neighborNode == null) continue;
          if (neighborNode.status == NodeStatus.firewall) continue;
          if (visited.contains(neighborId)) continue;

          visited.add(neighborId);
          nextFrontier.add(neighborId);

          if (neighborNode.status == NodeStatus.server) {
            serverInfected = true;
          }

          neighborNode.status = NodeStatus.infected;
        }
      }

      frontier = nextFrontier;
      notifyListeners();
    }

    await Future.delayed(const Duration(milliseconds: 400));

    isSimulating = false;
    notifyListeners();

    if (serverInfected) {
      return SimulationResult(
        title: 'Servidor comprometido',
        message: 'El virus llegó al servidor. La red fue vulnerada.',
        success: false,
      );
    }

    return SimulationResult(
      title: 'Servidor protegido',
      message: 'El ataque fue detenido. Los firewalls bloquearon la propagación.',
      success: true,
    );
  }

  void resetBoard() {
    nodes.clear();
    edges.clear();
    selectedNodeId = null;
    _nextNodeId = 1;
    isSimulating = false;
    currentMode = EditorMode.addNode;
    notifyListeners();
  }
}