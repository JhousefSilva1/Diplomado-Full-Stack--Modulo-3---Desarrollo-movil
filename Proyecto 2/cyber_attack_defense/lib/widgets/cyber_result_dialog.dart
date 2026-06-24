import 'package:cyber_attack_defense/constants/app_colors.dart';
import 'package:flutter/material.dart';



void showCyberResultDialog({
  required BuildContext context,
  required String title,
  required String message,
  required bool success,
}) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        backgroundColor: AppColors.dialogDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: success
                ? Colors.greenAccent.withOpacity(0.5)
                : Colors.redAccent.withOpacity(0.5),
          ),
        ),
        title: Row(
          children: [
            Icon(
              success ? Icons.verified_user : Icons.warning_amber_rounded,
              color: success ? Colors.greenAccent : Colors.redAccent,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Color(0xFFDDEEFF),
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}