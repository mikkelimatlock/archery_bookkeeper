# archery bookkeeper - project documentation

A professional archery scoring application built with Flutter, designed to match traditional paper scorecards with modern digital convenience.

## project overview

This Flutter application provides an intuitive scoring interface for archery practice and competition, featuring:

- Digital scorecard matching traditional paper layouts
- Real-time score calculation and running totals
- Configurable settings for different archery formats
- Color-coded scoring keypad for efficient input
- X/10/9 counting for precision tracking

The app follows clean architecture principles with a modular structure ready for scaling and advanced features.

## current implementation status

### ✅ completed features

**core UI components**:
- `ScoringPage`: Main application interface with settings and layout management
- `ScoringGrid`: Complete scorecard with End\Shot | #1 #2 #3 | Sum of 3 | Sum of 6 | Accumulative columns
- `ScoringKeypad`: 4x3 grid layout (X,10,9/8,7,6/5,4,3/2,1,M) plus CLEAR button with archery-standard color coding
- `ScoringCell`: Individual score input cells with selection highlighting and tap handling
- `ToggleSwitches`: Configuration options for 3/6 arrows per end and 10/12 ends per set

**scoring logic**:
- Automatic calculation of end totals (Sum of 3)
- Two-end totals (Sum of 6) displayed on even-numbered ends
- Real-time accumulative running totals
- X/10/9 counting with dedicated counters
- CLEAR functionality for score correction and editing
- Auto-advance input progression through scorecard

**visual design**:
- Color-coded keypad matching traditional archery scoring conventions
- Proper scorecard layout with clear column headers and row organization
- Final score display with X/10/9 counting section
- Material 3 theme with green color scheme

### 📋 architecture overview

```
lib/
├── config/              # Configuration and settings
│   ├── constants/       # App-wide constants
│   ├── localization/    # Multi-language support files
│   └── settings/        # User preferences and app config
├── core/                # Business logic and models
│   ├── calculators/     # Score calculation logic
│   ├── models/          # Data models (Arrow, End, Set, Match)
│   └── validators/      # Input validation logic
├── data/                # Data layer implementation
│   ├── database/        # SQLite database setup
│   ├── datasources/     # Local and remote data sources
│   ├── models/          # Data transfer objects
│   └── repositories/    # Data access layer
├── export/              # Score export functionality
├── presentation/        # UI layer
│   ├── controllers/     # State management controllers
│   ├── pages/          # Application screens
│   │   └── scoring_page.dart
│   └── widgets/        # Reusable UI components
│       ├── common/     # Shared widgets
│       │   └── toggle_switches.dart
│       └── scoring_grid/  # Scoring-specific widgets
│           ├── scoring_cell.dart
│           ├── scoring_grid.dart
│           └── scoring_keypad.dart
└── main.dart           # Application entry point
```

### 🎯 current functionality

**score input system**:
- Tap any cell in the scorecard to select it
- Use the keypad to input scores (X, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, M)
- Auto-advance moves to the next cell after score input
- CLEAR button removes score from selected cell

**calculation engine**:
- Real-time end totals with X=10, M=0 scoring
- Sum of 6 appears on even-numbered ends (2, 4, 6, etc.)
- Accumulative column shows running total through each end
- X/10/9 counters track precision shots
- Final score displayed prominently

**configuration options**:
- Toggle between 3 or 6 arrows per end
- Choose 10 or 12 ends per set
- Settings automatically reinitialize scorecard

Color scheme follows archery conventions:
- Gold/amber for X and 10 values (highest scores)
- Blue highlighting for end totals
- Yellow background for Sum of 6 calculations
- Green shading for accumulative totals

## next development priorities

### 🔧 core architecture improvements

1. **data models creation**:
   - `core/models/arrow.dart`: Individual arrow score with value and metadata
   - `core/models/end.dart`: Collection of arrows with calculations
   - `core/models/set.dart`: Collection of ends with set-level statistics
   - `core/models/match.dart`: Complete scoring session with settings

2. **score calculator refactoring**:
   - Move calculation logic from widgets to `core/calculators/score_calculator.dart`
   - Implement proper business logic separation
   - Add validation for score inputs

3. **state management implementation**:
   - Choose Provider or Riverpod for application state
   - Create proper state management for scoring sessions
   - Implement reactive UI updates

4. **data persistence layer**:
   - SQLite integration for local storage
   - Scoring session save/load functionality
   - Historical data tracking

### 🚀 feature development roadmap

**phase 1 - foundation**:
- Local storage implementation with SQLite
- Session management (new, save, load)
- Settings persistence using SharedPreferences
- Score validation and error handling

**phase 2 - user experience**:
- Session history page with saved scoring sessions
- Export system for score card images
- Physical keyboard support for desktop platforms
- Improved visual polish and responsiveness

**phase 3 - advanced features**:
- Multi-language support with JSON localization files
- Different archery round types (FITA, NFAA, etc.)
- Cloud synchronization with Google Drive integration
- Social sharing capabilities (Twitter, image sharing)

**phase 4 - competition features**:
- Multi-archer scoring support
- Tournament management capabilities
- Performance statistics and progress tracking
- Advanced export options (PDF reports, CSV data)

### 📱 platform considerations

**current support**:
- Android (tested and working)
- iOS (Flutter cross-platform ready)
- Web (Flutter web enabled)
- Desktop (Windows, macOS, Linux support available)

**responsive design**:
- Portrait orientation optimized
- Landscape support needed for tablets
- Desktop keyboard navigation
- Accessibility improvements for screen readers

## technical implementation notes

### dependencies

Current `pubspec.yaml` includes minimal dependencies:
- Flutter SDK ^3.9.0
- Material 3 theme support
- Cupertino icons for iOS consistency

Recommended additions for full implementation:
```yaml
dependencies:
  # State management
  provider: ^6.0.5
  # or
  flutter_riverpod: ^2.4.6
  
  # Database
  sqflite: ^2.3.0
  path: ^1.8.3
  
  # Storage
  shared_preferences: ^2.2.2
  
  # Export functionality
  image: ^4.1.3
  pdf: ^3.10.6
  
  # Internationalization
  intl: ^0.19.0
  
  # Development
  json_annotation: ^4.8.1

dev_dependencies:
  # Code generation
  build_runner: ^2.4.7
  json_serializable: ^6.7.1
```

### code organization principles

**separation of concerns**:
- Presentation layer handles only UI logic
- Business logic isolated in core modules
- Data access abstracted through repositories
- Configuration centralized in config modules

**testability**:
- Widget tests for UI components
- Unit tests for business logic
- Integration tests for complete workflows
- Mock implementations for external dependencies

**maintainability**:
- Clear naming conventions throughout
- Consistent file and directory organization
- Documentation for complex business rules
- Error handling at appropriate layers

## design decisions and rationale

### scorecard layout

The scoring grid exactly matches traditional paper scorecards to ensure familiar user experience:
- End numbers in left column for easy reference
- Arrow score columns (#1, #2, #3 or #1-#6)
- Calculated columns (Sum of 3, Sum of 6, Accumulative) match paper format
- X/10/9 counting section at bottom for quick reference

### keypad design

Button layout follows the user's exact specifications:
- 4x3 grid with logical score arrangement
- Color coding matches archery scoring conventions
- CLEAR button prominently placed for error correction
- Touch-friendly sizing for mobile devices

### auto-advance behavior

Score input automatically moves to the next logical cell:
- Within an end: moves from arrow #1 to #2 to #3
- Between ends: moves to arrow #1 of next end
- Reduces tap count and speeds up scoring process
- Can be overridden by tapping specific cells

### calculation accuracy

All score calculations follow official archery rules:
- X scores as 10 points in totals
- M (miss) scores as 0 points
- Sum of 6 only displays on even-numbered ends
- Accumulative totals include all previous ends
- Final score matches bottom accumulative cell

## file structure reference

### key implementation files

**main application**:
- `/lib/main.dart` - Application entry point and Material app setup
- `/lib/presentation/pages/scoring_page.dart` - Main scoring interface with state management

**scoring components**:
- `/lib/presentation/widgets/scoring_grid/scoring_grid.dart` - Complete scorecard with calculations
- `/lib/presentation/widgets/scoring_grid/scoring_cell.dart` - Individual score input cells
- `/lib/presentation/widgets/scoring_grid/scoring_keypad.dart` - 4x3 score input keypad
- `/lib/presentation/widgets/common/toggle_switches.dart` - Configuration toggles

**design references**:
- `/.uidesign/scorecard.xlsx` - Excel template with exact layout specifications
- `/.uidesign/keypad_layout.xlsx` - Keypad button colors and arrangement
- `/.uidesign/scorecard.pdf` - Visual reference for scorecard format

**configuration**:
- `/pubspec.yaml` - Flutter project configuration and dependencies
- `/analysis_options.yaml` - Dart analyzer rules and linting

## development workflow

### getting started

1. **environment setup**:
   ```bash
   flutter doctor
   flutter pub get
   ```

2. **running the application**:
   ```bash
   flutter run
   # or for specific platform
   flutter run -d chrome      # Web
   flutter run -d windows     # Windows desktop
   ```

3. **testing**:
   ```bash
   flutter test
   flutter test --coverage
   ```

### adding new features

1. **follow the modular architecture**:
   - Business logic goes in `core/`
   - UI components in `presentation/widgets/`
   - Data handling in `data/`

2. **maintain the design consistency**:
   - Reference `.uidesign/` files for visual specifications
   - Follow established color schemes and layouts
   - Test on multiple screen sizes

3. **update tests**:
   - Add unit tests for business logic
   - Create widget tests for new UI components
   - Include integration tests for complete workflows

## conclusion

The archery bookkeeper application has a solid foundation with a working scoring interface that matches traditional paper scorecards. The modular architecture provides a clear path for adding advanced features while maintaining code quality and testability.

The next development phase should focus on data persistence and proper state management to enable session saving and loading. This will transform the application from a calculator into a complete scoring solution for archery practitioners.

The user-provided design references ensure the application maintains authenticity to archery scoring conventions while leveraging modern digital capabilities for enhanced usability and functionality.