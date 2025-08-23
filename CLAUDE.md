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
- `ScoringGrid`: Complete responsive scorecard with static 12-row layout supporting both 3/6-arrow modes
- `ScoringKeypad`: 4x3 grid layout (X,10,9/8,7,6/5,4,3/2,1,M) plus CLEAR button with archery-standard color coding
- `ScoringCell`: Individual score input cells with selection highlighting and tap handling
- `ToggleSwitches`: Arrow count configuration (3/6 arrows per end) with automatic end inference

**scoring logic**:
- Dynamic calculation system with logical-to-visual end mapping
- Sum of 3 calculations: active in 3-arrow mode, greyed in 6-arrow mode
- Sum of 6 calculations: displays on odd visual rows in both modes
- Real-time accumulative running totals with proper bounds checking
- X/10/9 counting with dedicated counters
- CLEAR functionality for score correction and editing
- Auto-advance input progression through scorecard

**visual design & architecture**:
- Centralized color system with `ScoringColorScheme` class providing consistent theming
- Traditional and lowSaturation color schemes with explicit text/background color pairs
- Intelligent column greying: sum of 6 in 3-arrow mode, sum of 3 in 6-arrow mode
- Responsive percentage-based layout eliminating viewport overflow issues
- Clean merged header design with "Arrows" label replacing individual column indices
- Disabled state colors for conditional UI elements with seamless visual hierarchy
- Material 3 theme integration with archery-standard color conventions

**technical improvements**:
- Flutter lints upgraded to 6.0.0 for modern code quality standards
- Complete color architecture documentation in `_constants.md`
- Single source of truth for all score-related visual styling through `ScoringColors` class
- Performance-optimized compile-time color constants with no runtime overhead
- Static 12-row grid architecture replacing dynamic column spawning for stability
- Logical grouping system with proper visual-to-logical end mapping for accurate calculations

### 📋 architecture overview

```
lib/
├── config/              # Configuration and settings
│   ├── constants/       # App-wide constants and color systems
│   │   ├── scoring_colors.dart    # Centralized color scheme architecture
│   │   └── _constants.md         # Color system documentation
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
- Real-time end totals with X=10, M=0 scoring and proper bounds checking
- Mode-specific behavior: 3-arrow (10 ends) vs 6-arrow (6 ends) automatically inferred
- Sum of 3: active per row in 3-arrow mode, completely greyed in 6-arrow mode
- Sum of 6: displays on odd visual rows in both modes with correct 6-arrow grouping
- Accumulative column shows running total through each logical end
- X/10/9 counters track precision shots
- Final score displayed prominently

**configuration options**:
- Toggle between 3 or 6 arrows per end
- End count automatically inferred: 3-arrow mode = 10 ends (Indoor), 6-arrow mode = 6 ends (Outdoor)
- Settings automatically reinitialize scorecard with proper logical grouping

**adaptive color management**:
- Centralized `ScoringColorScheme` architecture with traditional and lowSaturation variants
- Intelligent sum of 6 column greying in 3-arrow mode while preserving layout
- Disabled state colors maintaining visual hierarchy for inactive elements
- Explicit text/background color pairs ensuring optimal contrast across all schemes

## next development priorities

### 🚧 immediate UI improvements (4 remaining)

**keypad interaction enhancements**:
- implement keypad pop-up behavior for better mobile UX
- prevent UI push-up when keypad appears on screen
- add auto-retract keypad functionality after score input
- include manual close button for keypad dismissal

**scorecard polish**:
- implement end grouping visual cues to highlight all cells of the currently selected end
- implement per-end descending sort for score organization

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

Current `pubspec.yaml` includes essential dependencies:
- Flutter SDK ^3.9.0 with Material 3 theme support
- Cupertino icons ^1.0.8 for iOS consistency
- Flutter lints ^6.0.0 for modern code quality standards
- Dependency overrides ensuring compatibility with latest Flutter versions

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

### centralized color architecture

The application features a sophisticated color management system with the `ScoringColorScheme` class providing consistent visual theming across all components.

**key architectural features**:
- Complete color system in `lib/config/constants/scoring_colors.dart`
- Traditional (vibrant) and lowSaturation (muted) color schemes available
- Explicit text/background color pairs preventing contrast issues
- Comprehensive disabled state support for conditional UI elements
- Performance-optimized compile-time constants with zero runtime overhead

**intelligent adaptive behavior**:
- Sum of 6 column automatically greys out in 3-arrow mode while maintaining layout
- Disabled states preserve visual hierarchy while clearly indicating inactive status
- Color scheme switching requires single constant change for global application
- Extensible architecture ready for additional themes (high contrast, dark mode, etc.)

See `lib/config/constants/_constants.md` for complete usage documentation and implementation examples.

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

**color architecture**:
- `/lib/config/constants/scoring_colors.dart` - Centralized color scheme definitions
- `/lib/config/constants/_constants.md` - Complete color system documentation

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

The archery bookkeeper application has evolved into a mature scoring interface with sophisticated visual architecture and polished user experience. The centralized color system, intelligent adaptive behavior, and optimized layouts create a professional-grade foundation that matches traditional paper scorecards while leveraging modern digital capabilities.

**current strength highlights**:
- Complete centralized color architecture with traditional and lowSaturation schemes
- Robust 6-arrow layout with static 12-row grid and logical-to-visual end mapping
- Responsive percentage-based layout eliminating viewport overflow issues
- Intelligent column greying maintaining layout consistency in both 3/6-arrow modes
- Modern development practices with flutter_lints 6.0.0 and performance-optimized constants
- Comprehensive documentation enabling easy maintenance and feature expansion

The remaining 4 UI improvements focus on keypad interaction polish and end grouping visual cues. With the major 6-arrow layout architecture now complete and stable, the foundation is ready for the next major development phase focusing on data persistence and state management to transform the application from a sophisticated calculator into a complete scoring and session management solution for archery practitioners.

The application successfully balances authenticity to archery scoring conventions with modern Flutter development practices, creating a clean, professional foundation ready for advanced features while maintaining code quality and visual consistency throughout.