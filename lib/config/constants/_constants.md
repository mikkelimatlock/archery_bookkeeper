# constants configuration guide

This directory contains the application's centralized constants and configuration system, providing consistent theming and behavior across all components.

## color scheme architecture

The archery bookkeeper uses a sophisticated color system built around the `ScoringColorScheme` class, which provides complete visual consistency for all scoring-related UI components.

### available color schemes

**traditional scheme (default)**:
- vibrant, high-contrast colors matching classic archery target rings
- bright gold for X/10/9 scores, vivid red for 8/7, bright blue for 6/5
- optimal for outdoor use and high visibility situations
- follows traditional archery color conventions

**lowSaturation scheme**:
- muted, eye-friendly colors for reduced strain during long sessions
- same color mapping but with reduced saturation and softer tones
- ideal for indoor use or extended practice sessions
- maintains accessibility while being easier on the eyes

### color system architecture

Each color scheme defines explicit colors for:
- **background colors**: one for each score value (X, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, M, CLEAR)
- **text colors**: intentionally chosen for each background to ensure readability
- **border colors**: selection highlighting and default cell borders
- **disabled states**: greyed-out versions for inactive UI elements

This architecture ensures:
- visual consistency across all scoring widgets
- easy theme switching without code changes
- proper text contrast on all backgrounds
- seamless disabled state handling for conditional UI elements

### switching color schemes

To change the active color scheme, edit the `_currentScheme` constant in `scoring_colors.dart`:

```dart
// Use traditional vibrant colors
static const ScoringColorScheme _currentScheme = traditional;

// Or switch to muted colors
static const ScoringColorScheme _currentScheme = lowSaturation;
```

The change applies instantly to all scoring components throughout the app.

### disabled state system

The color system includes dedicated disabled state colors that automatically grey out inactive elements while maintaining visual hierarchy:

```dart
// Apply disabled styling to any widget
Container(
  decoration: BoxDecoration(
    color: ScoringColors.getDisabledBackground(),
    border: Border.all(
      color: ScoringColors.getDisabledBorder(),
      width: 1.0,
    ),
  ),
  child: Text(
    'Sum of 6',
    style: TextStyle(
      color: ScoringColors.getDisabledText(),
    ),
  ),
)
```

This is used extensively for the sum of 6 column, which remains visible but greyed out when in 3-arrow end mode.

## usage patterns

### basic color application

```dart
import 'package:archery_bookkeeper/config/constants/scoring_colors.dart';

// Get colors for any score value
Color backgroundColor = ScoringColors.getScoreBackgroundColor('X');
Color textColor = ScoringColors.getScoreTextColor('X');
bool shouldBeBold = ScoringColors.shouldUseBoldText('X');

// Apply to a widget
Container(
  decoration: BoxDecoration(
    color: backgroundColor,
    border: Border.all(
      color: ScoringColors.getBorderColor(isSelected),
      width: ScoringColors.getBorderWidth(isSelected),
    ),
  ),
  child: Text(
    'X',
    style: TextStyle(
      color: textColor,
      fontWeight: shouldBeBold ? FontWeight.bold : FontWeight.normal,
    ),
  ),
)
```

### conditional disabled states

```dart
// Show as disabled when condition is false
Color bgColor = showColumn 
  ? ScoringColors.getScoreBackgroundColor('10')
  : ScoringColors.getDisabledBackground();

Color textColor = showColumn 
  ? ScoringColors.getScoreTextColor('10')
  : ScoringColors.getDisabledText();
```

### accessing color schemes directly

```dart
// Get the current active scheme
ScoringColorScheme current = ScoringColors.currentScheme;

// Access specific schemes for comparison or settings UI
ScoringColorScheme traditional = ScoringColors.availableTraditional;
ScoringColorScheme lowSat = ScoringColors.availableLowSaturation;

// Use scheme properties directly
Color goldBackground = traditional.goldRing;
Color goldText = traditional.goldText;
```

## adding new color schemes

To create additional color schemes (such as high contrast or colorblind-friendly variants):

1. **define the new scheme** in `scoring_colors.dart`:

```dart
static const ScoringColorScheme highContrast = ScoringColorScheme(
  // Background colors - use high contrast values
  goldRing: Color(0xFFFFFF00),        // Pure yellow
  redRing: Color(0xFFFF0000),         // Pure red
  blueRing: Color(0xFF0000FF),        // Pure blue
  blackRing: Color(0xFF000000),       // Pure black
  whiteRing: Color(0xFFFFFFFF),       // Pure white
  miss: Color(0xFF808080),            // Medium grey
  clear: Color(0xFFFF8000),           // Orange
  
  // Text colors - ensure maximum contrast
  goldText: Colors.black,
  redText: Colors.white,
  blueText: Colors.white,
  blackText: Colors.white,
  whiteText: Colors.black,
  missText: Colors.black,
  clearText: Colors.white,
  
  // Borders and disabled states
  selectedBorder: Color(0xFF0080FF),
  defaultBorder: Color(0xFF606060),
  disabledBackground: Color(0xFFE0E0E0),
  disabledText: Color(0xFF909090),
  disabledBorder: Color(0xFFC0C0C0),
);
```

2. **add an accessor method**:

```dart
static ScoringColorScheme get availableHighContrast => highContrast;
```

3. **switch to the new scheme** by updating `_currentScheme`:

```dart
static const ScoringColorScheme _currentScheme = highContrast;
```

## future expansion possibilities

The color system is designed for easy extension:

- **dark theme support**: add dark background schemes with appropriate text colors
- **accessibility themes**: high contrast, large text, colorblind-friendly variants
- **user customization**: runtime scheme switching with settings persistence
- **seasonal themes**: holiday or event-specific color schemes
- **tournament modes**: competition-specific color coding

### planned constants files

Other constants modules planned for the application:

- `app_constants.dart`: general app configuration (timeouts, limits, defaults)
- `layout_constants.dart`: UI spacing, sizing, and layout specifications  
- `scoring_rules.dart`: archery scoring rules and validation constants
- `export_constants.dart`: file formats, templates, and export configurations

## implementation notes

### why explicit text colors?

Instead of calculating text colors automatically, each scheme defines explicit text colors because:
- ensures intentional design decisions for every color combination
- prevents unexpected contrast issues when colors change
- allows for creative text color choices beyond simple black/white
- provides complete design control for complex color schemes

### disabled state philosophy

Disabled states maintain visual hierarchy while clearly indicating inactive status:
- elements remain visible to preserve layout and context
- consistent grey palette prevents confusion with active elements
- text remains readable while being clearly distinguished from active content
- used extensively in sum of 6 column when in 3-arrow end mode

### performance considerations

The color system is designed for performance:
- all colors are compile-time constants
- no runtime color calculations or theme switching overhead
- minimal method call overhead for color lookups
- ready for hot reload during development