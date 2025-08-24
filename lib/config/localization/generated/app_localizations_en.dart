// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Archery Bookkeeper';

  @override
  String get appVersion => 'Alpha 0.1';

  @override
  String get navMainScorer => 'Main (Scorer)';

  @override
  String get navSettings => 'Settings';

  @override
  String get arrowsPerEnd => 'Arrows per end';

  @override
  String get ruleset => 'Ruleset';

  @override
  String get rulesetIndoor => 'Indoor';

  @override
  String get rulesetOutdoor => 'Outdoor';

  @override
  String endsCount(int count) {
    return '$count ends';
  }

  @override
  String get headerEnd => 'End';

  @override
  String get headerArrows => 'Arrows';

  @override
  String get headerSumOf3 => 'Sum of 3';

  @override
  String get headerSumOf6 => 'Sum of 6';

  @override
  String get headerAccumulative => 'Accumulative';

  @override
  String get headerXCount => 'X';

  @override
  String get header10Count => '10';

  @override
  String get header9Count => '9';

  @override
  String get scoreTotal => 'Total';

  @override
  String get keypadClear => 'CLEAR';

  @override
  String get keypadClose => 'CLOSE';

  @override
  String get dialogClearScoresTitle => 'Clear scores';

  @override
  String get dialogClearScoresMessage =>
      'This will clear all scores for the current session. Continue?';

  @override
  String get dialogArrowChangeTitle => 'Change arrow count';

  @override
  String get dialogArrowChangeMessage =>
      'Changing arrow count will clear existing scores. Continue?';

  @override
  String get dialogPreserveScores => 'Preserve existing scores when possible?';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get dialogContinue => 'Continue';

  @override
  String get dialogYes => 'Yes';

  @override
  String get dialogNo => 'No';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsScoring => 'Scoring';

  @override
  String get settingsExport => 'Export';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsPlaceholder => 'This is a placeholder settings page.';

  @override
  String get settingsFutureWillInclude => 'Future settings will include:';

  @override
  String get settingsColorScheme => '• Color scheme preferences';

  @override
  String get settingsDefaultArrows => '• Default arrow counts';

  @override
  String get settingsScoreInput => '• Score input preferences';

  @override
  String get settingsExportOptions => '• Export settings';

  @override
  String get settingsSessionManagement => '• Session management';

  @override
  String get dialogKeepScoresTitle => 'Keep scores?';

  @override
  String get devTodoLocalization =>
      'REPLACE ALL THESE TEXTS WITH LOCALISATION MARKERS!!';
}
