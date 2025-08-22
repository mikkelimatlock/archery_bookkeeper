import 'package:flutter/material.dart';

/// Represents a complete color scheme for archery scoring components.
class ScoringColorScheme {
  // Background colors
  final Color goldRing;     // X, 10, 9
  final Color redRing;      // 8, 7
  final Color blueRing;     // 6, 5
  final Color blackRing;    // 4, 3
  final Color whiteRing;    // 2, 1
  final Color miss;         // M
  final Color clear;        // CLEAR button
  
  // Text colors
  final Color goldText;     // Text on gold ring
  final Color redText;      // Text on red ring
  final Color blueText;     // Text on blue ring
  final Color blackText;    // Text on black ring
  final Color whiteText;    // Text on white ring
  final Color missText;     // Text on miss
  final Color clearText;    // Text on CLEAR button
  
  // Border colors
  final Color selectedBorder;
  final Color defaultBorder;
  
  // Disabled/greyed-out colors for inactive elements
  final Color disabledBackground;
  final Color disabledText;
  final Color disabledBorder;

  const ScoringColorScheme({
    required this.goldRing,
    required this.redRing,
    required this.blueRing,
    required this.blackRing,
    required this.whiteRing,
    required this.miss,
    required this.clear,
    required this.goldText,
    required this.redText,
    required this.blueText,
    required this.blackText,
    required this.whiteText,
    required this.missText,
    required this.clearText,
    required this.selectedBorder,
    required this.defaultBorder,
    required this.disabledBackground,
    required this.disabledText,
    required this.disabledBorder,
  });
}

/// Centralized scoring color configuration for archery scoring components.
/// 
/// This class provides consistent color schemes across all scoring-related
/// widgets including scoring cells, keypad buttons, and visual indicators.
/// Supports multiple color schemes and future extensibility.
class ScoringColors {
  ScoringColors._();

  // Available color schemes
  
  /// Traditional vibrant archery colors - original scheme
  static const ScoringColorScheme traditional = ScoringColorScheme(
    goldRing: Color(0xEEffeb50),        // Bright yellow-gold
    redRing: Color(0xEEed3f36),         // Vibrant red
    blueRing: Color(0xEE01afd8),        // Bright blue
    blackRing: Color(0xEE222222),       // Dark grey
    whiteRing: Color(0xEEFFFFFF),       // Pure white
    miss: Color(0xEEcccccc),            // Light grey
    clear: Color(0xEEff8c42),           // Orange
    goldText: Colors.black,             // Black text on bright gold
    redText: Colors.white,              // White text on vibrant red
    blueText: Colors.white,             // White text on bright blue
    blackText: Colors.white,            // White text on dark grey
    whiteText: Colors.black,            // Black text on white background
    missText: Colors.black,             // Black text on light grey
    clearText: Colors.white,            // White text on orange
    selectedBorder: Colors.blue,
    defaultBorder: Color(0xEE999999),
    disabledBackground: Color(0xEEf0f0f0), // Light grey for disabled elements
    disabledText: Color(0xEEbbbbbb),    // Medium grey for disabled text
    disabledBorder: Color(0xEEdddddd),  // Very light grey for disabled borders
  );

  /// Low saturation scheme - muted colors for reduced eye strain
  static const ScoringColorScheme lowSaturation = ScoringColorScheme(
    goldRing: Color(0xEEd4c5a9),        // Muted gold/beige
    redRing: Color(0xEEb85450),         // Muted red/brown
    blueRing: Color(0xEE5a8aa8),        // Muted blue/grey
    blackRing: Color(0xEE444444),       // Lighter grey than traditional
    whiteRing: Color(0xEEf5f5f5),       // Off-white
    miss: Color(0xEEbbbbbb),            // Medium grey
    clear: Color(0xEEc49969),           // Muted orange/brown
    goldText: Color(0xEE333333),        // Dark grey on muted beige
    redText: Color(0xEEf0f0f0),         // Light grey on muted red
    blueText: Color(0xEEf0f0f0),        // Light grey on muted blue
    blackText: Color(0xEEf0f0f0),       // Light grey on darker grey
    whiteText: Color(0xEE333333),       // Dark grey on off-white
    missText: Color(0xEE333333),        // Dark grey on medium grey
    clearText: Color(0xEEf0f0f0),       // Light grey on muted orange
    selectedBorder: Color(0xEE6699bb),  // Muted blue border
    defaultBorder: Color(0xEE888888),   // Darker default border
    disabledBackground: Color(0xEEe8e8e8), // Muted light grey for disabled elements
    disabledText: Color(0xEEaaaaaa),    // Muted medium grey for disabled text
    disabledBorder: Color(0xEEcccccc),  // Muted light grey for disabled borders
  );

  // Current active scheme - change this to switch schemes globally
  static const ScoringColorScheme _currentScheme = traditional;
  
  /// Returns the background color for a given score value.
  /// Used by both scoring cells and keypad buttons for consistency.
  static Color getScoreBackgroundColor(String score) {
    if (score.isEmpty) return Colors.transparent;
    
    switch (score.toUpperCase()) {
      case 'X':
      case '10':
      case '9':
        return _currentScheme.goldRing;
      case '8':
      case '7':
        return _currentScheme.redRing;
      case '6':
      case '5':
        return _currentScheme.blueRing;
      case '4':
      case '3':
        return _currentScheme.blackRing;
      case '2':
      case '1':
        return _currentScheme.whiteRing;
      case 'CLEAR':
        return _currentScheme.clear;
      case 'M':
        return _currentScheme.miss;
      default:
        return _currentScheme.miss;
    }
  }
  
  /// Returns the appropriate text color for given score background.
  /// Uses explicit text colors defined in the current color scheme.
  static Color getScoreTextColor(String score) {
    if (score.isEmpty) return _currentScheme.whiteText; // Use scheme's default text color
    
    switch (score.toUpperCase()) {
      case 'X':
      case '10':
      case '9':
        return _currentScheme.goldText;
      case '8':
      case '7':
        return _currentScheme.redText;
      case '6':
      case '5':
        return _currentScheme.blueText;
      case '4':
      case '3':
        return _currentScheme.blackText;
      case '2':
      case '1':
        return _currentScheme.whiteText;
      case 'CLEAR':
        return _currentScheme.clearText;
      case 'M':
        return _currentScheme.missText;
      default:
        return _currentScheme.missText;
    }
  }
  
  /// Returns whether the score should be displayed with bold text.
  /// X and 10 scores are emphasized as highest values.
  static bool shouldUseBoldText(String score) {
    if (score.isEmpty) return false;
    return score.toUpperCase() == 'X' || score == '10';
  }
  
  /// Returns border color for scoring cells based on selection state.
  static Color getBorderColor(bool isSelected) {
    return isSelected ? _currentScheme.selectedBorder : _currentScheme.defaultBorder;
  }
  
  /// Returns border width for scoring cells based on selection state.
  static double getBorderWidth(bool isSelected) {
    return isSelected ? 2.0 : 1.0;
  }

  /// Returns colors for disabled/greyed-out elements
  static Color getDisabledBackground() => _currentScheme.disabledBackground;
  static Color getDisabledText() => _currentScheme.disabledText;
  static Color getDisabledBorder() => _currentScheme.disabledBorder;

  /// Returns the currently active color scheme
  static ScoringColorScheme get currentScheme => _currentScheme;
  
  /// Convenience method to switch to low saturation scheme
  /// To use: change _currentScheme = lowSaturation at the top of the class
  static ScoringColorScheme get availableLowSaturation => lowSaturation;
  
  /// Convenience method to switch to traditional scheme  
  /// To use: change _currentScheme = traditional at the top of the class
  static ScoringColorScheme get availableTraditional => traditional;

  // Future expansion: Additional color schemes
  // static const ScoringColorScheme highContrast = ScoringColorScheme(...);
  // static const ScoringColorScheme colorBlindFriendly = ScoringColorScheme(...);
  // static const ScoringColorScheme darkTheme = ScoringColorScheme(...);
}