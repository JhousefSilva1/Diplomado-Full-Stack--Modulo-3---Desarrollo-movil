import 'package:flutter/material.dart';

class NoSolutionDialog extends StatelessWidget {
  final VoidCallback onShuffleAgain;

  const NoSolutionDialog({
    super.key,
    required this.onShuffleAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: _dialogDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.redAccent,
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent,
                size: 48,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'No hay solución',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'El algoritmo A* no encontró una forma de resolver este estado del puzzle.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
                label: const Text(
                  'Cerrar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onShuffleAgain();
              },
              icon: const Icon(
                Icons.shuffle,
                color: Colors.white,
              ),
              label: const Text(
                'Mezclar otra vez',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _dialogDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      gradient: const LinearGradient(
        colors: [
          Color(0xFF4A148C),
          Color(0xFF7B1FA2),
          Color(0xFFBA68C8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}