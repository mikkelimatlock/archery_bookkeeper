import 'package:flutter/material.dart';
import '../../../config/constants/scoring_colors.dart';

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


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: ScoringColors.getScoreBackgroundColor(score),
          border: Border.all(
            color: ScoringColors.getBorderColor(isSelected),
            width: ScoringColors.getBorderWidth(isSelected),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            score,
            style: TextStyle(
              fontSize: 16,
              color: ScoringColors.getScoreTextColor(score),
              fontWeight: ScoringColors.shouldUseBoldText(score) ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}