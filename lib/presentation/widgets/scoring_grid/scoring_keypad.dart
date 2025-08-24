import 'package:flutter/material.dart';
import '../../../config/constants/scoring_colors.dart';

class ScoringKeypad extends StatelessWidget {
  final Function(String) onScoreInput;

  const ScoringKeypad({
    super.key,
    required this.onScoreInput,
  });

  @override
  Widget build(BuildContext context) {
    // Score buttons: 4 rows × 3 columns
    final List<List<String>> scoreLayout = [
      ['X', '10', '9'],
      ['8', '7', '6'],
      ['5', '4', '3'],
      ['2', '1', 'M'],
    ];
    
    // Functional buttons: 4 rows × 1 column
    final List<String> functionalButtons = [
      'CLEAR',
      'CLOSE',
      '', // Reserved for future functions
      '', // Reserved for future functions
    ];
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use Flex widgets for proper percentage distribution
        return Row(
          children: [
            // Score buttons section (77% width)
            Expanded(
              flex: 77,
              child: Column(
                children: List.generate(4, (rowIndex) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Row(
                        children: List.generate(3, (colIndex) {
                          final score = scoreLayout[rowIndex][colIndex];
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 1),
                              child: _buildKeypadButton(context, score),
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                }),
              ),
            ),
            
            const SizedBox(width: 2),
            
            // Functional buttons section (23% width)
            Expanded(
              flex: 23,
              child: Column(
                children: List.generate(4, (index) {
                  final buttonText = functionalButtons[index];
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: buttonText.isNotEmpty 
                        ? _buildKeypadButton(context, buttonText, isFunctional: true)
                        : Container(), // Empty container for reserved buttons
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKeypadButton(BuildContext context, String score, {bool isFunctional = false}) {
    // Use different styling for functional buttons
    Color buttonColor;
    Color textColor;
    
    if (isFunctional) {
      if (score == 'CLEAR') {
        buttonColor = Colors.red.shade400;
        textColor = Colors.white;
      } else if (score == 'CLOSE') {
        buttonColor = Colors.blue.shade400;
        textColor = Colors.white;
      } else {
        buttonColor = Colors.grey.shade300;
        textColor = Colors.grey.shade600;
      }
    } else {
      buttonColor = ScoringColors.getScoreBackgroundColor(score);
      textColor = ScoringColors.getScoreTextColor(score);
    }

    return ElevatedButton(
      onPressed: () => onScoreInput(score),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: textColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.zero,
      ),
      child: Text(
        score,
        style: TextStyle(
          fontSize: isFunctional ? 12 : (score.length > 1 ? 14 : 18),
          fontWeight: isFunctional ? FontWeight.bold : 
                     (ScoringColors.shouldUseBoldText(score) ? FontWeight.bold : FontWeight.w600),
        ),
      ),
    );
  }
}