import 'package:cyber_attack_defense/constants/app_colors.dart';
import 'package:cyber_attack_defense/core/enums/device_type.dart';
import 'package:cyber_attack_defense/widgets/device_type_selector.dart';
import 'package:flutter/material.dart';


import '../core/enums/editor_mode.dart';
import 'cyber_main_button.dart';
import 'cyber_small_button.dart';
import 'mode_button.dart';

class CyberActionPanel extends StatelessWidget {
  final EditorMode currentMode;
  final bool isSimulating;
  final ValueChanged<EditorMode> onModeChanged;
  final VoidCallback onSimulate;
  final VoidCallback onReset;
  final DeviceType selectedDeviceType;
  final ValueChanged<DeviceType> onDeviceTypeChanged;

  const CyberActionPanel({
    super.key,
    required this.currentMode,
    required this.isSimulating,
    required this.onModeChanged,
    required this.onSimulate,
    required this.onReset,
    required this.selectedDeviceType,
    required this.onDeviceTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
      decoration: BoxDecoration(
        color: AppColors.panelDark.withOpacity(0.96),
        border: Border(
          top: BorderSide(
            color: Colors.cyanAccent.withOpacity(0.18),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DeviceTypeSelector(
            selectedDeviceType: selectedDeviceType,
            onChanged: onDeviceTypeChanged,
          ),
const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              ModeButton(
                label: 'Nodo',
                icon: Icons.add_circle_outline,
                mode: EditorMode.addNode,
                currentMode: currentMode,
                onTap: onModeChanged,
              ),
              ModeButton(
                label: 'Cable',
                icon: Icons.device_hub,
                mode: EditorMode.connect,
                currentMode: currentMode,
                onTap: onModeChanged,
              ),
              ModeButton(
                label: 'Servidor',
                icon: Icons.dns,
                mode: EditorMode.server,
                currentMode: currentMode,
                onTap: onModeChanged,
              ),
              ModeButton(
                label: 'Virus',
                icon: Icons.bug_report,
                mode: EditorMode.virus,
                currentMode: currentMode,
                onTap: onModeChanged,
              ),
              ModeButton(
                label: 'Firewall',
                icon: Icons.shield,
                mode: EditorMode.firewall,
                currentMode: currentMode,
                onTap: onModeChanged,
              ),
              ModeButton(
                label: 'Borrar',
                icon: Icons.delete_outline,
                mode: EditorMode.erase,
                currentMode: currentMode,
                onTap: onModeChanged,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CyberMainButton(
                  text: isSimulating ? 'Simulando...' : 'Simular ataque',
                  icon: Icons.play_arrow_rounded,
                  onPressed: isSimulating ? null : onSimulate,
                ),
              ),
              const SizedBox(width: 10),
              CyberSmallButton(
                icon: Icons.refresh,
                onPressed: isSimulating ? null : onReset,
              ),
            ],
          ),
        ],
      ),
    );
  }
}