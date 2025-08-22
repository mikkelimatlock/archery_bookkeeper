import 'package:flutter/material.dart';
import '../widgets/scoring_grid/scoring_grid.dart';
import '../widgets/scoring_grid/scoring_keypad.dart';
import '../widgets/common/toggle_switches.dart';

class ScoringPage extends StatefulWidget {
  const ScoringPage({super.key});

  @override
  State<ScoringPage> createState() => _ScoringPageState();
}

class _ScoringPageState extends State<ScoringPage> {
  int arrowsPerEnd = 3;
  int endsPerSet = 12;
  int selectedRow = 0;
  int selectedColumn = 0;
  List<List<String>> scores = [];

  @override
  void initState() {
    super.initState();
    _initializeScores();
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
      _initializeScores();
    });
  }

  void _onEndsPerSetChanged(int ends) {
    setState(() {
      endsPerSet = ends;
      _initializeScores();
    });
  }

  void _onCellSelected(int row, int column) {
    setState(() {
      selectedRow = row;
      selectedColumn = column;
    });
  }

  void _onScoreInput(String score) {
    if (score == 'CLEAR') {
      // Clear the selected cell
      if (selectedRow < scores.length && selectedColumn < scores[selectedRow].length) {
        setState(() {
          scores[selectedRow][selectedColumn] = '';
        });
      }
    } else {
      // Input score
      if (selectedRow < scores.length && selectedColumn < scores[selectedRow].length) {
        setState(() {
          scores[selectedRow][selectedColumn] = score;
          // Auto-advance to next cell
          if (selectedColumn < arrowsPerEnd - 1) {
            selectedColumn++;
          } else if (selectedRow < endsPerSet - 1) {
            selectedRow++;
            selectedColumn = 0;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archery Scoring'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Settings toggles
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ToggleSwitches(
              arrowsPerEnd: arrowsPerEnd,
              endsPerSet: endsPerSet,
              onArrowsPerEndChanged: _onArrowsPerEndChanged,
              onEndsPerSetChanged: _onEndsPerSetChanged,
            ),
          ),
          
          // Scoring grid
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ScoringGrid(
                scores: scores,
                arrowsPerEnd: arrowsPerEnd,
                endsPerSet: endsPerSet,
                selectedRow: selectedRow,
                selectedColumn: selectedColumn,
                onCellSelected: _onCellSelected,
              ),
            ),
          ),
          
          // Scoring keypad
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ScoringKeypad(
                onScoreInput: _onScoreInput,
              ),
            ),
          ),
        ],
      ),
    );
  }
}