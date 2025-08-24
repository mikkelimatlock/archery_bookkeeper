# Flutter Rename Tool

A comprehensive Python script to rename Flutter applications across all platform configurations. This tool handles package names, display names, class names, and bundle identifiers consistently across Android, iOS, and Flutter files.

## Features

- **Automatic detection** of current app configuration across all platforms
- **Default value support** - Press ENTER to keep current values unchanged
- **Smart change detection** - Only proceed if changes are actually needed
- **Comprehensive validation** for package names and app display names
- **Synchronized updates** across all platform files:
  - `pubspec.yaml` - Package name and description
  - `lib/main.dart` - App title and main class name
  - `android/app/src/main/AndroidManifest.xml` - Android app label
  - `android/app/build.gradle.kts` - Android namespace and applicationId
  - `ios/Runner/Info.plist` - iOS display name and bundle name
- **Automatic Flutter refresh** - Runs `flutter clean` and `flutter pub get` after successful rename
- **Preview and confirmation** before making changes
- **Safe execution** with validation and error handling

## Usage

### Interactive Mode

Run the script from your Flutter project root:

```bash
python tools/flutter_rename.py
```

The script will:
1. Detect your current app configuration
2. Prompt for new package name and app display name
3. Show a preview of all changes
4. Ask for confirmation before applying changes
5. Update all relevant files

### Example Session

```
Flutter App Renaming Tool
============================================================

============================================================
CURRENT APP CONFIGURATION
============================================================
Package Name        : archery_bookkeeper
Description         : Archery scoring companion.
App Title           : Archery Bookkeeper
Main Class          : ArcheryBookkeeperApp
Android Label       : archery_bookkeeper
Ios Display Name    : Archery Bookkeeper
Ios Bundle Name     : archery_bookkeeper
============================================================

============================================================
ENTER NEW APP CONFIGURATION
============================================================
Press ENTER to keep current value, or type new value:

New package name (current: archery_scorer): archery_scorecard
New app display name (current: Archery Scoresheet): Archery Scorecard

============================================================
PREVIEW OF CHANGES
============================================================
Package Name     : archery_bookkeeper → archery_scorecard
App Display Name : Archery Bookkeeper → Archery Scorecard
Main Class Name  : ArcheryBookkeeperApp → ArcheryScorecardApp
============================================================

Files to be updated:
  ✓ pubspec.yaml
  ✓ lib/main.dart
  ✓ android/app/src/main/AndroidManifest.xml
  ✓ android/app/build.gradle.kts
  ✓ ios/Runner/Info.plist

This operation will modify the above files.
Proceed with renaming? (y/N): y

Applying changes...
----------------------------------------
✓ Updated pubspec.yaml
✓ Updated main.dart
✓ Updated Android manifest
✓ Updated Android build.gradle.kts
✓ Moved and updated MainActivity.kt
  From: J:\dev\archery_bookkeeper\android\app\src\main\kotlin\com\novoyuuparosk\old_app
  To:   J:\dev\archery_bookkeeper\android\app\src\main\kotlin\com\novoyuuparosk\new_app
✓ Updated test files: widget_test.dart
✓ Updated iOS Info.plist
----------------------------------------
Rename completed: 7/7 files updated successfully

✓ All files updated successfully!

Refreshing Flutter project...
----------------------------------------
Running 'flutter clean'...
✓ flutter clean completed
Running 'flutter pub get'...
✓ flutter pub get completed

============================================================
✓ Project refresh completed successfully!

Your Flutter app has been renamed and is ready to use.
You can now run 'flutter run' to test the app.
```

## Validation Rules

### Package Name
- Must start with a lowercase letter
- Can contain only lowercase letters, numbers, and underscores
- Cannot start or end with underscore
- Cannot contain consecutive underscores
- Cannot be a Dart reserved word

### App Display Name
- Must be at least 2 characters long
- Cannot exceed 50 characters
- Cannot be empty or contain only whitespace

## Files Modified

The script updates the following files:

1. **`pubspec.yaml`**
   - `name:` field (package name)
   - `description:` field (generated from app name)

2. **`lib/main.dart`**
   - `title:` in MaterialApp (app display name)
   - Main class name and constructor
   - `runApp()` instantiation

3. **`android/app/src/main/AndroidManifest.xml`**
   - `android:label` attribute in application tag

4. **`android/app/build.gradle.kts`**
   - `namespace` (Android namespace)
   - `applicationId` (Android application identifier)

5. **`android/app/src/main/kotlin/.../MainActivity.kt`**
   - Updates package declaration
   - Moves file to match new package structure

6. **`test/**/*.dart`**
   - Updates package imports in test files
   - Updates class name references in tests

7. **`ios/Runner/Info.plist`**
   - `CFBundleDisplayName` (iOS display name)
   - `CFBundleName` (iOS bundle name)

## Testing

Test the detection and validation functionality:

```bash
python tools/test_detection.py
```

This will show current configuration detection and test validation rules.

## User Experience Features

### Default Values
When prompted for input, simply press ENTER to keep the current value:
```
New package name (current: archery_scorer): 
Using current value: archery_scorer
```

### Smart Change Detection
The script detects if no actual changes are needed:
```
============================================================
No changes detected - configuration is already up to date.
============================================================
```

### Automatic Project Refresh
After successful renaming, the script automatically runs:
- `flutter clean` to clear build cache
- `flutter pub get` to refresh dependencies

No manual steps required - your app is ready to run immediately.

## Post-Rename Steps

If automatic Flutter refresh succeeds:
1. **Test the application**: `flutter run`
2. **Verify on all target platforms** (Android, iOS, Web, etc.)

If automatic refresh fails (fallback):
1. **Clean build cache**: `flutter clean`
2. **Refresh dependencies**: `flutter pub get`
3. **Test the application**: `flutter run`
4. **Verify on all target platforms**

## Safety Features

- **Non-destructive preview** - Shows exactly what will change before applying
- **File existence checks** - Warns about missing files
- **Comprehensive validation** - Prevents invalid names
- **Error handling** - Reports specific issues if updates fail
- **Backup recommendation** - Always commit your changes to version control first

## Requirements

- Python 3.8 or higher
- Must be run from Flutter project root directory
- All target platform files should exist (created by `flutter create`)

## Troubleshooting

**Issue**: "File not found" warnings
- **Solution**: Ensure you're running from the Flutter project root directory

**Issue**: Some files not updated
- **Solution**: Check file permissions and ensure files are not read-only

**Issue**: Invalid package name error
- **Solution**: Follow Dart package naming conventions (lowercase, underscores only)

**Issue**: App doesn't reflect changes after rename
- **Solution**: Run `flutter clean` and `flutter pub get`, then rebuild

**Issue**: Android app crashes with ClassNotFoundException after rename
- **Solution**: This indicates the MainActivity wasn't moved to the new package structure - the script now handles this automatically

**Issue**: Tests fail after renaming due to old package imports or class names
- **Solution**: The script now automatically updates test files with new imports and class references

## Best Practices

### Test Writing for Renamed Apps
When writing tests, use structural widget checks instead of text-based assertions:

```dart
// Good - completely localization-safe and robust
expect(find.byType(MaterialApp), findsOneWidget);
expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
expect(find.byIcon(Icons.menu), findsOneWidget);
expect(find.byKey(const Key('specific-widget')), findsOneWidget);

// Avoid - brittle and breaks with localization  
expect(find.text('Specific Text'), findsOneWidget);
expect(find.byTooltip('Open navigation menu'), findsOneWidget);
```