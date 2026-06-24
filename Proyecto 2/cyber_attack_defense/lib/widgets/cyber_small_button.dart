import 'package:flutter/material.dart';

class CyberSmallButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const CyberSmallButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.1),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.withOpacity(0.2),
          disabledForegroundColor: Colors.white.withOpacity(0.5),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: Icon(icon),
      ),
    );
  }
}