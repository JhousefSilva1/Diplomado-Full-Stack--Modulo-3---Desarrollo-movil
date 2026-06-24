import 'package:flutter/material.dart';

import '../core/enums/device_type.dart';

class DeviceTypeSelector extends StatelessWidget {
  final DeviceType selectedDeviceType;
  final ValueChanged<DeviceType> onChanged;

  const DeviceTypeSelector({
    super.key,
    required this.selectedDeviceType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<DeviceType>(
      value: selectedDeviceType,
      dropdownColor: const Color(0xFF07111F),
      decoration: InputDecoration(
        labelText: 'Tipo de dispositivo',
        labelStyle: const TextStyle(
          color: Color(0xFFB4EFFF),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.cyanAccent.withOpacity(0.20),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.cyanAccent.withOpacity(0.65),
          ),
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      items: DeviceType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Row(
            children: [
              Icon(
                _getDeviceIcon(type),
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(_getDeviceName(type)),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) return;
        onChanged(value);
      },
    );
  }

  IconData _getDeviceIcon(DeviceType type) {
    switch (type) {
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

  String _getDeviceName(DeviceType type) {
    switch (type) {
      case DeviceType.computer:
        return 'Computadora';

      case DeviceType.laptop:
        return 'Laptop';

      case DeviceType.phone:
        return 'Celular';

      case DeviceType.printer:
        return 'Impresora';

      case DeviceType.router:
        return 'Router';

      case DeviceType.camera:
        return 'Cámara IP';

      case DeviceType.tablet:
        return 'Tablet';
    }
  }
}