import 'package:flutter/material.dart';
import 'views/cyber_attack_defense_view.dart';

void main() {
  runApp(const CyberAttackDefenseApp());
}

class CyberAttackDefenseApp extends StatelessWidget {
  const CyberAttackDefenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CyberAttack Defense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
      ),
      home: const CyberAttackDefenseView(),
    );
  }
}