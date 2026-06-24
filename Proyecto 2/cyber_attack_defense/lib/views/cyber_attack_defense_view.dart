import 'package:cyber_attack_defense/constants/app_colors.dart';
import 'package:cyber_attack_defense/controller/cyber_attack_controller.dart';
import 'package:flutter/material.dart';
import '../painters/network_painter.dart';
import '../widgets/cyber_action_panel.dart';
import '../widgets/cyber_header.dart';
import '../widgets/cyber_result_dialog.dart';

class CyberAttackDefenseView extends StatefulWidget {
  const CyberAttackDefenseView({super.key});

  @override
  State<CyberAttackDefenseView> createState() => _CyberAttackDefenseViewState();
}

class _CyberAttackDefenseViewState extends State<CyberAttackDefenseView> {
  late final CyberAttackController controller;

  @override
  void initState() {
    super.initState();
    controller = CyberAttackController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _simulateAttack() async {
    final result = await controller.simulateAttack();

    if (!mounted) return;

    showCyberResultDialog(
      context: context,
      title: result.title,
      message: result.message,
      success: result.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.3,
                colors: [
                  AppColors.backgroundTop,
                  AppColors.backgroundMiddle,
                  AppColors.backgroundBottom,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const CyberHeader(),

                  Expanded(
                    child: GestureDetector(
                      onTapDown: (details) {
                        controller.handleTap(details.localPosition);
                      },
                      child: CustomPaint(
                        painter: NetworkPainter(
                          nodes: controller.nodes,
                          edges: controller.edges,
                          selectedNodeId: controller.selectedNodeId,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ),

                  CyberActionPanel(
                    currentMode: controller.currentMode,
                    isSimulating: controller.isSimulating,
                    selectedDeviceType: controller.selectedDeviceType,
                    onModeChanged: controller.changeMode,
                    onDeviceTypeChanged: controller.changeDeviceType,
                    onSimulate: _simulateAttack,
                    onReset: controller.resetBoard,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}