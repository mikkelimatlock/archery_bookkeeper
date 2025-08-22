# Constants Directory

This directory contains application-wide constants and configuration.

## Files

- **scoring_colors.dart**: Centralized color scheme system for all scoring-related UI components
  - Provides multiple color schemes: `traditional` (vibrant) and `lowSaturation` (muted)
  - Follows archery ring color conventions (gold, red, blue, black, white)
  - Explicit text colors defined per scheme for intentional design control
  - Disabled state colors for greying out inactive UI elements
  - Single source of truth for all score-related colors with easy scheme switching
  - Architecture ready for dark themes, high contrast, and colorblind-friendly schemes

## Future Expansion

Planned constants files:
- `app_constants.dart`: General app configuration (timeouts, limits, defaults)
- `layout_constants.dart`: UI spacing, sizing, and layout specifications  
- `scoring_rules.dart`: Archery scoring rules and validation constants
- `export_constants.dart`: File formats, templates, and export configurations

## Usage

```dart
import 'package:archery_bookkeeper/config/constants/scoring_colors.dart';

// Get background color for any score (uses current active scheme)
Color bgColor = ScoringColors.getScoreBackgroundColor('X');

// Get appropriate text color with automatic contrast calculation
Color textColor = ScoringColors.getScoreTextColor('X');

// Check if score should be bold
bool isBold = ScoringColors.shouldUseBoldText('10');

// Access available schemes
ScoringColorScheme traditional = ScoringColors.availableTraditional;
ScoringColorScheme lowSat = ScoringColors.availableLowSaturation;

// Get disabled state colors
Color disabledBg = ScoringColors.getDisabledBackground();
Color disabledText = ScoringColors.getDisabledText();
Color disabledBorder = ScoringColors.getDisabledBorder();

// Switch schemes by changing _currentScheme in scoring_colors.dart:
// static const ScoringColorScheme _currentScheme = lowSaturation;
```