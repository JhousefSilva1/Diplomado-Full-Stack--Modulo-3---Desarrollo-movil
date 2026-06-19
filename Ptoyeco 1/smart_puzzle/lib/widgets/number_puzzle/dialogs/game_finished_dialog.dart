import 'package:flutter/material.dart';

class GameFinishedDialog extends StatelessWidget {
  final String time;
  final String moves;
  final VoidCallback onPlayAgain;

  const GameFinishedDialog({
    super.key,
    required this.time,
    required this.moves,
    required this.onPlayAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: _dialogDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildWinnerIcon(),

            const SizedBox(height: 20),

            const Text(
              '¡Puzzle completado!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Excelente trabajo',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                _buildResultCard(
                  icon: Icons.timer,
                  value: time,
                  label: 'Tiempo',
                ),

                const SizedBox(width: 12),

                _buildResultCard(
                  icon: Icons.touch_app,
                  value: moves,
                  label: 'Movimientos',
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onPlayAgain();
                },
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Jugar otra vez',
                  style: TextStyle(
                    fontSize: 17,
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

            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'Volver al menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
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
      borderRadius: BorderRadius.circular(28),
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

  Widget _buildWinnerIcon() {
    return Container(
      width: 86,
      height: 86,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.amber,
          width: 3,
        ),
      ),
      child: const Icon(
        Icons.emoji_events,
        color: Colors.amber,
        size: 52,
      ),
    );
  }

  Widget _buildResultCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),

            const SizedBox(height: 8),

            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}