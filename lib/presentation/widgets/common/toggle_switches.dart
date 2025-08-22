import 'package:flutter/material.dart';

class ToggleSwitches extends StatelessWidget {
  final int arrowsPerEnd;
  final int endsPerSet;
  final Function(int) onArrowsPerEndChanged;
  final Function(int) onEndsPerSetChanged;

  const ToggleSwitches({
    super.key,
    required this.arrowsPerEnd,
    required this.endsPerSet,
    required this.onArrowsPerEndChanged,
    required this.onEndsPerSetChanged,
  });

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
            _buildToggleGroup(
              'Ends per set',
              [10, 12],
              endsPerSet,
              onEndsPerSetChanged,
            ),
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
}