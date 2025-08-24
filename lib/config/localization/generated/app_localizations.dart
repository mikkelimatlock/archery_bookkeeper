import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Archery Bookkeeper'**
  String get appTitle;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Alpha 0.1'**
  String get appVersion;

  /// No description provided for @navMainScorer.
  ///
  /// In en, this message translates to:
  /// **'Main (Scorer)'**
  String get navMainScorer;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @arrowsPerEnd.
  ///
  /// In en, this message translates to:
  /// **'Arrows per end'**
  String get arrowsPerEnd;

  /// No description provided for @ruleset.
  ///
  /// In en, this message translates to:
  /// **'Ruleset'**
  String get ruleset;

  /// No description provided for @rulesetIndoor.
  ///
  /// In en, this message translates to:
  /// **'Indoor'**
  String get rulesetIndoor;

  /// No description provided for @rulesetOutdoor.
  ///
  /// In en, this message translates to:
  /// **'Outdoor'**
  String get rulesetOutdoor;

  /// No description provided for @endsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} ends'**
  String endsCount(int count);

  /// No description provided for @headerEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get headerEnd;

  /// No description provided for @headerArrows.
  ///
  /// In en, this message translates to:
  /// **'Arrows'**
  String get headerArrows;

  /// No description provided for @headerSumOf3.
  ///
  /// In en, this message translates to:
  /// **'Sum of 3'**
  String get headerSumOf3;

  /// No description provided for @headerSumOf6.
  ///
  /// In en, this message translates to:
  /// **'Sum of 6'**
  String get headerSumOf6;

  /// No description provided for @headerAccumulative.
  ///
  /// In en, this message translates to:
  /// **'Accumulative'**
  String get headerAccumulative;

  /// No description provided for @headerXCount.
  ///
  /// In en, this message translates to:
  /// **'X'**
  String get headerXCount;

  /// No description provided for @header10Count.
  ///
  /// In en, this message translates to:
  /// **'10'**
  String get header10Count;

  /// No description provided for @header9Count.
  ///
  /// In en, this message translates to:
  /// **'9'**
  String get header9Count;

  /// No description provided for @scoreTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get scoreTotal;

  /// No description provided for @keypadClear.
  ///
  /// In en, this message translates to:
  /// **'CLEAR'**
  String get keypadClear;

  /// No description provided for @keypadClose.
  ///
  /// In en, this message translates to:
  /// **'CLOSE'**
  String get keypadClose;

  /// No description provided for @dialogClearScoresTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear scores'**
  String get dialogClearScoresTitle;

  /// No description provided for @dialogClearScoresMessage.
  ///
  /// In en, this message translates to:
  /// **'This will clear all scores for the current session. Continue?'**
  String get dialogClearScoresMessage;

  /// No description provided for @dialogArrowChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Change arrow count'**
  String get dialogArrowChangeTitle;

  /// No description provided for @dialogArrowChangeMessage.
  ///
  /// In en, this message translates to:
  /// **'Changing arrow count will clear existing scores. Continue?'**
  String get dialogArrowChangeMessage;

  /// No description provided for @dialogPreserveScores.
  ///
  /// In en, this message translates to:
  /// **'Preserve existing scores when possible?'**
  String get dialogPreserveScores;

  /// No description provided for @dialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogCancel;

  /// No description provided for @dialogContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get dialogContinue;

  /// No description provided for @dialogYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get dialogYes;

  /// No description provided for @dialogNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get dialogNo;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsScoring.
  ///
  /// In en, this message translates to:
  /// **'Scoring'**
  String get settingsScoring;

  /// No description provided for @settingsExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get settingsExport;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'This is a placeholder settings page.'**
  String get settingsPlaceholder;

  /// No description provided for @settingsFutureWillInclude.
  ///
  /// In en, this message translates to:
  /// **'Future settings will include:'**
  String get settingsFutureWillInclude;

  /// No description provided for @settingsColorScheme.
  ///
  /// In en, this message translates to:
  /// **'• Color scheme preferences'**
  String get settingsColorScheme;

  /// No description provided for @settingsDefaultArrows.
  ///
  /// In en, this message translates to:
  /// **'• Default arrow counts'**
  String get settingsDefaultArrows;

  /// No description provided for @settingsScoreInput.
  ///
  /// In en, this message translates to:
  /// **'• Score input preferences'**
  String get settingsScoreInput;

  /// No description provided for @settingsExportOptions.
  ///
  /// In en, this message translates to:
  /// **'• Export settings'**
  String get settingsExportOptions;

  /// No description provided for @settingsSessionManagement.
  ///
  /// In en, this message translates to:
  /// **'• Session management'**
  String get settingsSessionManagement;

  /// No description provided for @dialogKeepScoresTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep scores?'**
  String get dialogKeepScoresTitle;

  /// No description provided for @devTodoLocalization.
  ///
  /// In en, this message translates to:
  /// **'REPLACE ALL THESE TEXTS WITH LOCALISATION MARKERS!!'**
  String get devTodoLocalization;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fi':
      return AppLocalizationsFi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
