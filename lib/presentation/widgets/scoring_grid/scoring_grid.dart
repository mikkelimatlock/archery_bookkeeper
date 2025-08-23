import 'package:flutter/material.dart';
import 'scoring_cell.dart';
import '../../../config/constants/scoring_colors.dart';

class ScoringGrid extends StatelessWidget {
  final List<List<String>> scores;
  final int arrowsPerEnd;
  final int endsPerSet;
  final int selectedRow;
  final int selectedColumn;
  final int? activeEndIndex;
  final Function(int row, int column) onCellSelected;

  const ScoringGrid({
    super.key,
    required this.scores,
    required this.arrowsPerEnd,
    required this.endsPerSet,
    required this.selectedRow,
    required this.selectedColumn,
    this.activeEndIndex,
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

  // Visual-to-logical mapping helpers
  int _getLogicalEndFromVisualRow(int visualRow) {
    if (arrowsPerEnd == 3) {
      // 3-arrow mode: 1 visual row = 1 logical end
      return visualRow;
    } else {
      // 6-arrow mode: 2 visual rows = 1 logical end
      return visualRow ~/ 2;
    }
  }
  
  int _getArrowIndexFromVisualPosition(int visualRow, int column) {
    if (arrowsPerEnd == 3) {
      // 3-arrow mode: column directly maps to arrow index
      return column;
    } else {
      // 6-arrow mode: row within end determines arrow offset
      final rowWithinEnd = visualRow % 2;
      return (rowWithinEnd * 3) + column;
    }
  }
  
  bool _isVisualRowActive(int visualRow) {
    if (arrowsPerEnd == 3) {
      return visualRow < 10; // 10 ends for 3-arrow mode
    } else {
      return visualRow < 12; // All 12 rows active for 6-arrow mode
    }
  }
  
  // Fixed sum calculations using logical groupings
  int _calculateSumOfThreeForLogicalEnd(int logicalEnd) {
    if (logicalEnd >= scores.length) return 0;
    
    // For 3-arrow mode: sum first 3 arrows
    // For 6-arrow mode: sum first 3 arrows (arrows 0-2)
    int total = 0;
    final maxArrows = arrowsPerEnd == 3 ? 3 : 3; // Always sum first 3 arrows for Sum of 3
    
    for (int i = 0; i < maxArrows && i < scores[logicalEnd].length; i++) {
      final score = scores[logicalEnd][i];
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
  
  int _calculateSumOfSixForLogicalEnd(int logicalEnd) {
    if (arrowsPerEnd == 6) {
      // 6-arrow mode: sum all 6 arrows of this logical end
      return _calculateEndTotal(scores[logicalEnd]);
    } else {
      // 3-arrow mode: sum this end + previous end (6 arrows total)
      if (logicalEnd % 2 == 1 && logicalEnd > 0) {
        return _calculateEndTotal(scores[logicalEnd - 1]) + _calculateEndTotal(scores[logicalEnd]);
      }
    }
    return 0;
  }
  
  
  bool _isVisualRowInActiveEnd(int visualRow) {
    if (activeEndIndex == null) return false;
    
    final logicalEnd = _getLogicalEndFromVisualRow(visualRow);
    return logicalEnd == activeEndIndex;
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
                // End column: ~13% (50/395)
                Expanded(
                  flex: 13,
                  child: Center(child: Text('End\\Shot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                ),
                // Arrow columns: ~42% (165/395)
                Expanded(
                  flex: 42,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Arrows', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                // Sum of 3: ~14% (55/395)
                Expanded(
                  flex: 14,
                  child: Center(
                    child: Text(
                      'Sum of 3', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 12,
                        color: arrowsPerEnd == 6 ? ScoringColors.getDisabledText() : null,
                      ),
                    ),
                  ),
                ),
                // Sum of 6: ~14% (55/395)
                Expanded(
                  flex: 14,
                  child: Center(
                    child: Text(
                      'Sum of 6', 
                      style: const TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                // Accumulative: ~17% (70/395)
                Expanded(
                  flex: 17,
                  child: Center(child: Text('Accumulative', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                ),
              ],
            ),
          ),
          
          // Scoring rows - always 12 static rows
          Expanded(
            child: ListView.builder(
              itemCount: 12, // Always 12 visual rows regardless of ruleset
              itemBuilder: (context, visualRow) {
                // Use logical grouping approach
                final isActiveRow = _isVisualRowActive(visualRow);
                final logicalEnd = isActiveRow ? _getLogicalEndFromVisualRow(visualRow) : -1;
                final rowsPerEnd = arrowsPerEnd == 6 ? 2 : 1;
                final rowWithinEnd = visualRow % rowsPerEnd;
                
                // Calculate sums using logical groupings with bounds checking
                final sumOfThree = (isActiveRow && logicalEnd >= 0 && logicalEnd < scores.length) 
                    ? _calculateSumOfThreeForLogicalEnd(logicalEnd) : 0;
                final sumOfSix = (isActiveRow && logicalEnd >= 0 && logicalEnd < scores.length) 
                    ? _calculateSumOfSixForLogicalEnd(logicalEnd) : 0;
                final accumulative = (isActiveRow && logicalEnd >= 0 && logicalEnd < scores.length) 
                    ? _calculateAccumulative(logicalEnd) : 0;
                
                return Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: [
                      // End number (only show on first row of each end)
                      Expanded(
                        flex: 13,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isActiveRow ? Colors.grey.shade100 : ScoringColors.getDisabledBackground(),
                            border: Border(
                              right: BorderSide(
                                color: isActiveRow ? Colors.grey.shade300 : ScoringColors.getDisabledBorder(),
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              (isActiveRow && rowWithinEnd == 0 && logicalEnd >= 0) ? '#${logicalEnd + 1}' : '',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: isActiveRow ? null : ScoringColors.getDisabledText(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Arrow cells section - 42% total width split evenly among 3 columns
                      Expanded(
                        flex: 42,
                        child: Row(
                          children: List.generate(3, (column) {
                            // Use logical grouping to determine arrow index
                            final arrowIndex = _getArrowIndexFromVisualPosition(visualRow, column);
                            final actualRow = logicalEnd;
                            final actualColumn = arrowIndex;
                            
                            // Check if this cell should be active
                            final cellActive = isActiveRow && arrowIndex < arrowsPerEnd && 
                                             logicalEnd >= 0 && logicalEnd < scores.length;
                            
                            return Expanded(
                              child: cellActive ? ScoringCell(
                                score: scores[actualRow][actualColumn],
                                isSelected: selectedRow == actualRow && selectedColumn == actualColumn,
                                isInActiveEnd: _isVisualRowInActiveEnd(visualRow),
                                onTap: () => onCellSelected(actualRow, actualColumn),
                              ) : Container(
                                decoration: BoxDecoration(
                                  color: ScoringColors.getDisabledBackground(),
                                  border: Border.all(color: ScoringColors.getDisabledBorder()),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      
                      // Sum of 3 (end total) - completely greyed in 6-arrow mode
                      Expanded(
                        flex: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: (arrowsPerEnd == 6 || !isActiveRow) 
                              ? ScoringColors.getDisabledBackground()
                              : Colors.blue.shade50,
                            border: Border(
                              left: BorderSide(
                                color: (arrowsPerEnd == 6 || !isActiveRow)
                                  ? ScoringColors.getDisabledBorder()
                                  : Colors.grey.shade300,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              // Show Sum of 3 only in 3-arrow mode on the single row per end
                              (arrowsPerEnd == 6 || !isActiveRow) ? '' : sumOfThree.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: (arrowsPerEnd == 6 || !isActiveRow)
                                  ? ScoringColors.getDisabledText()
                                  : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Sum of 6 - different logic for 3-arrow vs 6-arrow mode
                      Expanded(
                        flex: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: !isActiveRow || visualRow % 2 == 0
                              ? ScoringColors.getDisabledBackground()
                              : Colors.yellow.shade100,
                            border: Border(
                              left: BorderSide(
                                color: !isActiveRow || visualRow % 2 == 0
                                  ? ScoringColors.getDisabledBorder()
                                  : Colors.grey.shade300,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              // Show Sum of 6 on odd visual rows (0-indexed), when sum is available
                              !isActiveRow || sumOfSix == 0 || visualRow % 2 == 0
                                ? '' : sumOfSix.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: !isActiveRow || visualRow % 2 == 0
                                  ? ScoringColors.getDisabledText()
                                  : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Accumulative (running total) - show on last row of each end
                      Expanded(
                        flex: 17,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: !isActiveRow || (arrowsPerEnd == 6 && rowWithinEnd == 0)
                              ? ScoringColors.getDisabledBackground()
                              : Colors.green.shade50,
                            border: Border(
                              left: BorderSide(
                                color: !isActiveRow || (arrowsPerEnd == 6 && rowWithinEnd == 0)
                                  ? ScoringColors.getDisabledBorder()
                                  : Colors.grey.shade300,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              // Show accumulative only on last row of each logical end
                              !isActiveRow || (arrowsPerEnd == 6 && rowWithinEnd == 0)
                                ? '' : accumulative.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: !isActiveRow || (arrowsPerEnd == 6 && rowWithinEnd == 0)
                                  ? ScoringColors.getDisabledText()
                                  : null,
                              ),
                            ),
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