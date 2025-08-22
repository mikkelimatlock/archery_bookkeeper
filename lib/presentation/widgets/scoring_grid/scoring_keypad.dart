import 'package:flutter/material.dart';

class ScoringKeypad extends StatelessWidget {
  final Function(String) onScoreInput;

  const ScoringKeypad({
    super.key,
    required this.onScoreInput,
  });

  @override
  Widget build(BuildContext context) {
    // Keypad layout matching user's design: 4 rows × 3 columns + CLEAR
    final List<List<String>> keypadLayout = [
      ['X', '10', '9'],
      ['8', '7', '6'],
      ['5', '4', '3'],
      ['2', '1', 'M'],
    ];
    
    return Column(
      children: [
        // Main keypad grid (4×3)
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              final row = index ~/ 3;
              final col = index % 3;
              final score = keypadLayout[row][col];
              return _buildKeypadButton(context, score);
            },
          ),
        ),
        
        const SizedBox(height: 8),
        
        // CLEAR button (full width)
        SizedBox(
          width: double.infinity,
          height: 50,
          child: _buildKeypadButton(context, 'CLEAR', isWide: true),
        ),
      ],
    );
  }

  Widget _buildKeypadButton(BuildContext context, String score, {bool isWide = false}) {
    Color buttonColor;
    Color textColor = Colors.black;
    
    // Color scheme matching your design
    // TODO: Update this to match `scoring_cell.dart`
    switch (score) {
      case 'X':
        buttonColor = Colors.amber.shade300;
        break;
      case '10':
        buttonColor = Colors.amber.shade300;
        break;
      case '9':
        buttonColor = Colors.yellow.shade300;
        break;
      case '8':
        buttonColor = Colors.red.shade400;
        textColor = Colors.white;
        break;
      case '7':
        buttonColor = Colors.red.shade400;
        textColor = Colors.white;
        break;
      case '6':
        buttonColor = Colors.blue.shade400;
        textColor = Colors.white;
        break;
      case '5':
        buttonColor = Colors.blue.shade400;
        textColor = Colors.white;
        break;
      case '4':
        buttonColor = Colors.black87;
        textColor = Colors.white;
        break;
      case '3':
        buttonColor = Colors.black87;
        textColor = Colors.white;
        break;
      case 'M':
        buttonColor = Colors.grey.shade400;
        break;
      case 'CLEAR':
        buttonColor = Colors.orange.shade400;
        textColor = Colors.white;
        break;
      default:
        buttonColor = Colors.grey.shade300;
        break;
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
          fontSize: isWide ? 16 : (score.length > 1 ? 14 : 18),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}