import 'package:flutter/material.dart';

class ToggleSwitches extends StatelessWidget {
  final int arrowsPerEnd;
  final Function(int) onArrowsPerEndChanged;

  const ToggleSwitches({
    super.key,
    required this.arrowsPerEnd,
    required this.onArrowsPerEndChanged,
  });
  
  // Inferred ends per set based on ruleset
  int get endsPerSet => arrowsPerEnd == 3 ? 10 : 6;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildToggleGroup(
              'Arrows per end',
              [3, 6],
              arrowsPerEnd,
              onArrowsPerEndChanged,
            ),
            _buildRulesetInfo(),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleGroup(
    String label,
    List<int> options,
    int currentValue,
    Function(int) onChanged,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ToggleButtons(
          isSelected: options.map((option) => option == currentValue).toList(),
          onPressed: (index) => onChanged(options[index]),
          borderRadius: BorderRadius.circular(8),
          selectedColor: Colors.white,
          fillColor: Colors.green,
          color: Colors.grey.shade700,
          constraints: const BoxConstraints(
            minHeight: 40,
            minWidth: 50,
          ),
          children: options.map((option) => Text(option.toString())).toList(),
        ),
      ],
    );
  }
  
  Widget _buildRulesetInfo() {
    final rulesetName = arrowsPerEnd == 3 ? 'Indoor' : 'Outdoor';
    return Column(
      children: [
        Text(
          'Ruleset',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            border: Border.all(color: Colors.blue.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                rulesetName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              Text(
                '$endsPerSet ends',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}