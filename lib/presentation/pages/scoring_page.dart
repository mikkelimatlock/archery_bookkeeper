import 'package:flutter/material.dart';
import '../widgets/scoring_grid/scoring_grid.dart';
import '../widgets/scoring_grid/scoring_keypad.dart';
import '../widgets/common/toggle_switches.dart';

class ScoringPage extends StatefulWidget {
  const ScoringPage({super.key});

  @override
  State<ScoringPage> createState() => _ScoringPageState();
}

class _ScoringPageState extends State<ScoringPage> with SingleTickerProviderStateMixin {
  int arrowsPerEnd = 3;
  int endsPerSet = 12;
  int selectedRow = 0;
  int selectedColumn = 0;
  List<List<String>> scores = [];
  bool isKeypadVisible = false;
  int? activeEndIndex;
  late AnimationController _animationController;
  late Animation<double> _keypadAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _keypadAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _initializeScores();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeScores() {
    scores = List.generate(
      endsPerSet,
      (index) => List.generate(arrowsPerEnd, (index) => ''),
    );
  }

  void _onArrowsPerEndChanged(int arrows) {
    setState(() {
      arrowsPerEnd = arrows;
      // Infer ends per set based on ruleset
      endsPerSet = arrows == 3 ? 10 : 6;
      _initializeScores();
    });
  }

  void _sortEndScores(int endIndex) {
    if (endIndex < 0 || endIndex >= scores.length) return;
    
    List<String> endScores = List.from(scores[endIndex]);
    
    // Separate empty and non-empty scores
    List<String> nonEmptyScores = endScores.where((score) => score.isNotEmpty).toList();
    List<String> emptyScores = endScores.where((score) => score.isEmpty).toList();
    
    // Sort non-empty scores in descending order (X > 10 > 9 > ... > 1 > M)
    nonEmptyScores.sort((a, b) {
      int getScoreValue(String score) {
        if (score == 'X') return 11;
        if (score == 'M') return -1;
        return int.tryParse(score) ?? 0;
      }
      return getScoreValue(b).compareTo(getScoreValue(a));
    });
    
    // Combine sorted non-empty scores with empty scores
    List<String> sortedScores = [...nonEmptyScores, ...emptyScores];
    
    // Update scores array
    scores[endIndex] = sortedScores;
  }

  int _findFirstEmptyCellInEnd(int endIndex) {
    if (endIndex < 0 || endIndex >= scores.length) return 0;
    
    for (int i = 0; i < arrowsPerEnd; i++) {
      if (i < scores[endIndex].length && scores[endIndex][i].isEmpty) {
        return i;
      }
    }
    return 0; // Fallback to first cell if all filled
  }

  void _onCellSelected(int row, int column) {
    setState(() {
      selectedRow = row;
      activeEndIndex = row;
      
      if (!isKeypadVisible) {
        isKeypadVisible = true;
        _animationController.forward();
      }
      
      // If selecting an empty cell, snap to first empty cell in end
      if (column < scores[row].length && scores[row][column].isEmpty) {
        selectedColumn = _findFirstEmptyCellInEnd(row);
      } else {
        selectedColumn = column;
      }
    });
  }

  void _onBackgroundTapped() {
    if (isKeypadVisible) {
      _animationController.reverse().then((_) {
        setState(() {
          isKeypadVisible = false;
          activeEndIndex = null;
          selectedRow = -1;
          selectedColumn = -1;
        });
      });
    }
  }


  void _onScoreInput(String score) {
    if (score == 'CLOSE') {
      // Close keypad - same as background tap
      _onBackgroundTapped();
      return;
    }
    
    if (selectedRow < 0 || selectedRow >= scores.length) return;
    
    if (score == 'CLEAR') {
      // Clear the selected cell
      if (selectedColumn < scores[selectedRow].length && scores[selectedRow][selectedColumn].isNotEmpty) {
        scores[selectedRow][selectedColumn] = '';
        _sortEndScores(selectedRow);
        // Retract keypad and disarm after clearing
        _animationController.reverse().then((_) {
          setState(() {
            isKeypadVisible = false;
            activeEndIndex = null;
            selectedRow = -1;
            selectedColumn = -1;
          });
        });
      }
    } else {
      // Input score
      if (selectedColumn < scores[selectedRow].length) {
        // Check if this was an empty cell before we modify it
        bool wasEmpty = scores[selectedRow][selectedColumn].isEmpty;
        
        setState(() {
          scores[selectedRow][selectedColumn] = score;
          _sortEndScores(selectedRow);
          
          if (wasEmpty) {
            // Find next empty cell in same end
            int nextEmptyCell = _findFirstEmptyCellInEnd(selectedRow);
            bool hasMoreEmptyInEnd = nextEmptyCell < arrowsPerEnd && 
                                    nextEmptyCell < scores[selectedRow].length && 
                                    scores[selectedRow][nextEmptyCell].isEmpty;
            
            if (hasMoreEmptyInEnd) {
              // Move to next empty cell in same end
              selectedColumn = nextEmptyCell;
            } else {
              // End is complete - disarm completely
              _animationController.reverse().then((_) {
                setState(() {
                  isKeypadVisible = false;
                  activeEndIndex = null;
                  selectedRow = -1;
                  selectedColumn = -1;
                });
              });
            }
          } else {
            // Was editing existing cell - disarm after modification
            _animationController.reverse().then((_) {
              setState(() {
                isKeypadVisible = false;
                activeEndIndex = null;
                selectedRow = -1;
                selectedColumn = -1;
              });
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _keypadAnimation,
      builder: (context, child) {
        // Calculate viewport heights based on animation progress
        // AppBar is in parent navigation, account for status bar and safe area
        final availableHeight = (MediaQuery.of(context).size.height - 
                               MediaQuery.of(context).padding.top - 
                               kToolbarHeight).clamp(200.0, double.infinity); // Minimum 200px
        
        final keypadHeight = (availableHeight * 0.30 * _keypadAnimation.value).clamp(0.0, availableHeight * 0.30);
        final upperViewportHeight = (availableHeight - keypadHeight).clamp(100.0, availableHeight);
        
        return Scaffold(
          body: GestureDetector(
            onTap: _onBackgroundTapped,
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                // Upper viewport - Settings and Scoring grid (scrollable)
                SizedBox(
                  height: upperViewportHeight,
                  child: Column(
                    children: [
                      // Settings toggles
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ToggleSwitches(
                          arrowsPerEnd: arrowsPerEnd,
                          onArrowsPerEndChanged: _onArrowsPerEndChanged,
                        ),
                      ),
                      
                      // Scoring grid (scrollable within upper viewport)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ScoringGrid(
                            scores: scores,
                            arrowsPerEnd: arrowsPerEnd,
                            endsPerSet: endsPerSet,
                            selectedRow: selectedRow,
                            selectedColumn: selectedColumn,
                            activeEndIndex: activeEndIndex,
                            onCellSelected: _onCellSelected,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Lower viewport - Keypad (animated height)
                if (keypadHeight > 0)
                  SizedBox(
                    height: keypadHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                      ),
                      child: Opacity(
                        opacity: _keypadAnimation.value,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ScoringKeypad(
                            onScoreInput: _onScoreInput,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}