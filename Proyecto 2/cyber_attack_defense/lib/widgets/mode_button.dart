import 'package:cyber_attack_defense/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../core/enums/editor_mode.dart';

class ModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final EditorMode mode;
  final EditorMode currentMode;
  final ValueChanged<EditorMode> onTap;

  const ModeButton({
    super.key,
    required this.label,
    required this.icon,
    required this.mode,
    required this.currentMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = currentMode == mode;

    return GestureDetector(
      onTap: () {
        onTap(mode);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [
                    AppColors.cyan,
                    AppColors.blue,
                  ],
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? Colors.white.withOpacity(0.55)
                : Colors.white.withOpacity(0.12),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.35),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}