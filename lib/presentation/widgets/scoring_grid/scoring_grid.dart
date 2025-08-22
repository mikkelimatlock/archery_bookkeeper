import 'package:flutter/material.dart';
import 'scoring_cell.dart';
import '../../../config/constants/scoring_colors.dart';

class ScoringGrid extends StatelessWidget {
  final List<List<String>> scores;
  final int arrowsPerEnd;
  final int endsPerSet;
  final int selectedRow;
  final int selectedColumn;
  final Function(int row, int column) onCellSelected;

  const ScoringGrid({
    super.key,
    required this.scores,
    required this.arrowsPerEnd,
    required this.endsPerSet,
    required this.selectedRow,
    required this.selectedColumn,
    required this.onCellSelected,
  });

  int _calculateEndTotal(List<String> endScores) {
    int total = 0;
    for (String score in endScores) {
      if (score == 'X') {
        total += 10;
      } else if (score == 'M' || score.isEmpty) {
        total += 0;
      } else {
        total += int.tryParse(score) ?? 0;
      }
    }
    return total;
  }

  int _calculateSumOfSix(int endIndex) {
    // Calculate sum of two consecutive ends (for even-numbered ends)
    if (endIndex % 2 == 1 && endIndex > 0) {
      return _calculateEndTotal(scores[endIndex - 1]) + _calculateEndTotal(scores[endIndex]);
    }
    return 0;
  }

  int _calculateAccumulative(int endIndex) {
    int total = 0;
    for (int i = 0; i <= endIndex && i < scores.length; i++) {
      total += _calculateEndTotal(scores[i]);
    }
    return total;
  }

  Map<String, int> _calculateXAndTenCounts() {
    int xCount = 0;
    int tenCount = 0;
    int nineCount = 0;
    
    for (var end in scores) {
      for (var score in end) {
        if (score == 'X') {
          xCount++;
        } else if (score == '10') {
          tenCount++;
        } else if (score == '9') {
          nineCount++;
        }
      }
    }
    
    return {'X': xCount, '10': tenCount, '9': nineCount};
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 50, child: Center(child: Text('End\\Shot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))),
                ...List.generate(arrowsPerEnd, (index) => 
                  SizedBox(width: 55, child: Center(child: Text('#${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold))))),
                const SizedBox(width: 55, child: Center(child: Text('Sum of 3', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))),
                SizedBox(
                  width: 55, 
                  child: Center(
                    child: Text(
                      'Sum of 6', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 12,
                        color: arrowsPerEnd == 3 ? ScoringColors.getDisabledText() : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 70, child: Center(child: Text('Accumulative', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))),
              ],
            ),
          ),
          
          // Scoring rows
          Expanded(
            child: ListView.builder(
              itemCount: endsPerSet,
              itemBuilder: (context, row) {
                final endTotal = _calculateEndTotal(scores[row]);
                final sumOfSix = _calculateSumOfSix(row);
                final accumulative = _calculateAccumulative(row);
                
                return Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: [
                      // End number
                      Container(
                        width: 50,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          border: Border(
                            right: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '#${row + 1}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      
                      // Arrow score cells
                      ...List.generate(arrowsPerEnd, (column) => 
                        SizedBox(
                          width: 55,
                          child: ScoringCell(
                            score: scores[row][column],
                            isSelected: selectedRow == row && selectedColumn == column,
                            onTap: () => onCellSelected(row, column),
                          ),
                        ),
                      ),
                      
                      // Sum of 3 (end total)
                      Container(
                        width: 55,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          border: Border(
                            left: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            endTotal.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      
                      // Sum of 6 (two-end total, only for even rows)
                      Container(
                        width: 55,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: arrowsPerEnd == 3 
                            ? ScoringColors.getDisabledBackground()
                            : (row % 2 == 1 ? Colors.yellow.shade100 : Colors.transparent),
                          border: Border(
                            left: BorderSide(
                              color: arrowsPerEnd == 3 
                                ? ScoringColors.getDisabledBorder()
                                : Colors.grey.shade300,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            (arrowsPerEnd == 3 || sumOfSix == 0) ? '' : sumOfSix.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: arrowsPerEnd == 3 
                                ? ScoringColors.getDisabledText()
                                : null,
                            ),
                          ),
                        ),
                      ),
                      
                      // Accumulative (running total)
                      Container(
                        width: 70,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          border: Border(
                            left: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            accumulative.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // X/10/9 counting and final score section
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                top: BorderSide(color: Colors.grey.shade400, width: 2),
              ),
            ),
            child: _buildCountingSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildCountingSection() {
    final counts = _calculateXAndTenCounts();
    final finalScore = _calculateAccumulative(scores.length - 1);
    
    return Row(
      children: [
        // X count
        Container(
          width: 60,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('X', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(counts['X'].toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        
        const SizedBox(width: 8),
        
        // 10 count
        Container(
          width: 60,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('10', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(counts['10'].toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        
        const SizedBox(width: 8),
        
        // 9 count
        Container(
          width: 60,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.yellow.shade100,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('9', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(counts['9'].toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        
        const Spacer(),
        
        // Final score
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            border: Border.all(color: Colors.grey.shade400, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Final score', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                finalScore.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ],
          ),
        ),
      ],
    );
  }
}