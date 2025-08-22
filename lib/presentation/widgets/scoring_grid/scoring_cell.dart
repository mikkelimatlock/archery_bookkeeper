import 'package:flutter/material.dart';

class ScoringCell extends StatelessWidget {
  final String score;
  final bool isSelected;
  final VoidCallback onTap;

  const ScoringCell({
    super.key,
    required this.score,
    required this.isSelected,
    required this.onTap,
  });

  Color _getScoreColor(String score) {
    switch (score) {
      case 'X':
      case '10':
      case '9':
        return Color(0xEEffeb50);
      case '8':
      case '7':
        return Color(0xEEed3f36);
      case '6':
      case '5':
        return Color(0xEE01afd8);
      case '4':
      case '3':
        return Color(0xEE222222);
      case '2':
      case '1':
        return Color(0xEEFFFFFF);
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _getScoreColor(score),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade400,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            score,
            style: TextStyle(
              fontSize: 16,
              fontWeight: score == 'X' || score == '10' ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}