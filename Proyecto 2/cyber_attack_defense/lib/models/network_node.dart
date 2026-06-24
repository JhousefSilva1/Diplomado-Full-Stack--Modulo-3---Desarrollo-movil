import 'package:flutter/material.dart';

import '../core/enums/device_type.dart';
import '../core/enums/node_status.dart';

class NetworkNode {
  final int id;
  Offset position;
  NodeStatus status;
  DeviceType deviceType;

  NetworkNode({
    required this.id,
    required this.position,
    this.status = NodeStatus.normal,
    this.deviceType = DeviceType.computer,
  });
}