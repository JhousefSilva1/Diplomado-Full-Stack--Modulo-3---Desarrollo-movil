import 'package:cyber_attack_defense/models/network_node.dart';
import 'package:flutter/material.dart';

import '../core/enums/node_status.dart';
import '../models/network_edge.dart';
import '../core/enums/device_type.dart';


class NetworkPainter extends CustomPainter {
  final List<NetworkNode> nodes;
  final List<NetworkEdge> edges;
  final int? selectedNodeId;

  NetworkPainter({
    required this.nodes,
    required this.edges,
    required this.selectedNodeId,
  });

  static const double nodeRadius = 25;

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);
    _drawEdges(canvas);
    _drawNodes(canvas);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.035)
      ..strokeWidth = 1;

    const gap = 32.0;

    for (double x = 0; x <= size.width; x += gap) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    for (double y = 0; y <= size.height; y += gap) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
  }

  void _drawEdges(Canvas canvas) {
    for (final edge in edges) {
      final fromNode = _getNode(edge.from);
      final toNode = _getNode(edge.to);

      if (fromNode == null || toNode == null) continue;

      final isDangerLine = fromNode.status == NodeStatus.infected ||
          toNode.status == NodeStatus.infected;

      final shadowPaint = Paint()
        ..color = isDangerLine
            ? Colors.redAccent.withOpacity(0.22)
            : Colors.cyanAccent.withOpacity(0.18)
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      canvas.drawLine(
        fromNode.position,
        toNode.position,
        shadowPaint,
      );

      final linePaint = Paint()
        ..shader = LinearGradient(
          colors: isDangerLine
              ? [
                  Colors.redAccent.withOpacity(0.95),
                  Colors.deepOrangeAccent.withOpacity(0.85),
                ]
              : [
                  Colors.cyanAccent.withOpacity(0.85),
                  Colors.blueAccent.withOpacity(0.7),
                ],
        ).createShader(
          Rect.fromPoints(fromNode.position, toNode.position),
        )
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        fromNode.position,
        toNode.position,
        linePaint,
      );
    }
  }

  void _drawNodes(Canvas canvas) {
    for (final node in nodes) {
      final bool isSelected = selectedNodeId == node.id;

      final nodeColors = _getNodeColors(node.status);
      final iconData = _getIcon(node);
      final shadowPaint = Paint()
        ..color = nodeColors.first.withOpacity(0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

      canvas.drawCircle(
        node.position,
        nodeRadius + 5,
        shadowPaint,
      );

      final outerPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            nodeColors.first,
            nodeColors.last,
          ],
        ).createShader(
          Rect.fromCircle(
            center: node.position,
            radius: nodeRadius,
          ),
        );

      canvas.drawCircle(
        node.position,
        nodeRadius,
        outerPaint,
      );

      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.22);

      canvas.drawCircle(
        node.position.translate(-8, -9),
        8,
        highlightPaint,
      );

      final borderPaint = Paint()
        ..color = isSelected ? Colors.white : Colors.white.withOpacity(0.35)
        ..strokeWidth = isSelected ? 3.5 : 1.4
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(
        node.position,
        nodeRadius,
        borderPaint,
      );

      _drawIcon(
        canvas: canvas,
        icon: iconData,
        center: node.position,
        color: Colors.white,
      );

      _drawNodeId(canvas, node);
    }
  }

  void _drawIcon({
    required Canvas canvas,
    required IconData icon,
    required Offset center,
    required Color color,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: 23,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  void _drawNodeId(Canvas canvas, NetworkNode node) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${node.id}',
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final idPosition = node.position.translate(
      -textPainter.width / 2,
      nodeRadius + 4,
    );

    textPainter.paint(canvas, idPosition);
  }

  List<Color> _getNodeColors(NodeStatus status) {
    switch (status) {
      case NodeStatus.normal:
        return [
          const Color(0xFF00E5FF),
          const Color(0xFF1565C0),
        ];

      case NodeStatus.server:
        return [
          const Color(0xFFFFF176),
          const Color(0xFFFF8F00),
        ];

      case NodeStatus.infected:
        return [
          const Color(0xFFFF5252),
          const Color(0xFFB71C1C),
        ];

      case NodeStatus.firewall:
        return [
          const Color(0xFF69F0AE),
          const Color(0xFF00A152),
        ];
    }
  }

IconData _getIcon(NetworkNode node) {
  if (node.status == NodeStatus.server) {
    return Icons.dns;
  }

  if (node.status == NodeStatus.infected) {
    return Icons.bug_report;
  }

  if (node.status == NodeStatus.firewall) {
    return Icons.shield;
  }

  switch (node.deviceType) {
    case DeviceType.computer:
      return Icons.desktop_windows;

    case DeviceType.laptop:
      return Icons.laptop_mac;

    case DeviceType.phone:
      return Icons.phone_android;

    case DeviceType.printer:
      return Icons.print;

    case DeviceType.router:
      return Icons.router;

    case DeviceType.camera:
      return Icons.videocam;

    case DeviceType.tablet:
      return Icons.tablet_mac;
  }
}

  NetworkNode? _getNode(int id) {
    try {
      return nodes.firstWhere((node) => node.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  bool shouldRepaint(covariant NetworkPainter oldDelegate) {
    return true;
  }
}