import 'package:flutter/material.dart';

class PuzzleStats extends StatelessWidget {
  final String time;
  final String moves;

  const PuzzleStats({
    super.key,
    required this.time,
    required this.moves,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.timer,
          value: time,
          label: 'Tiempo',
        ),

        const SizedBox(width: 14),

        _buildStatCard(
          icon: Icons.touch_app,
          value: moves,
          label: 'Movimientos',
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),

            const SizedBox(height: 6),

            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

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