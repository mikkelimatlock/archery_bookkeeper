// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'Jousiammunnan tuloskirja';

  @override
  String get appVersion => 'Alpha 0.1';

  @override
  String get navMainScorer => 'Pääsivu (Tuloslaskuri)';

  @override
  String get navSettings => 'Asetukset';

  @override
  String get arrowsPerEnd => 'Nuolia per päätös';

  @override
  String get ruleset => 'Sääntökokoelma';

  @override
  String get rulesetIndoor => 'Sisärata';

  @override
  String get rulesetOutdoor => 'Ulkorata';

  @override
  String endsCount(int count) {
    return '$count päätöstä';
  }

  @override
  String get headerEnd => 'Päätös';

  @override
  String get headerArrows => 'Nuolet';

  @override
  String get headerSumOf3 => 'Summa 3';

  @override
  String get headerSumOf6 => 'Summa 6';

  @override
  String get headerAccumulative => 'Yhteensä';

  @override
  String get headerXCount => 'X';

  @override
  String get header10Count => '10';

  @override
  String get header9Count => '9';

  @override
  String get scoreTotal => 'Yhteensä';

  @override
  String get keypadClear => 'TYHJENNÄ';

  @override
  String get keypadClose => 'SULJE';

  @override
  String get dialogClearScoresTitle => 'Tyhjennä pisteet';

  @override
  String get dialogClearScoresMessage =>
      'Tämä tyhjentää kaikki pisteet nykyiseltä kierrokselta. Jatka?';

  @override
  String get dialogArrowChangeTitle => 'Muuta nuolien määrää';

  @override
  String get dialogArrowChangeMessage =>
      'Nuolien määrän muuttaminen tyhjentää olemassa olevat pisteet. Jatka?';

  @override
  String get dialogPreserveScores =>
      'Säilytetäänkö olemassa olevat pisteet mahdollisuuksien mukaan?';

  @override
  String get dialogCancel => 'Peruuta';

  @override
  String get dialogContinue => 'Jatka';

  @override
  String get dialogYes => 'Kyllä';

  @override
  String get dialogNo => 'Ei';

  @override
  String get settingsTitle => 'Asetukset';

  @override
  String get settingsAppearance => 'Ulkoasu';

  @override
  String get settingsScoring => 'Pisteidenlasku';

  @override
  String get settingsExport => 'Vienti';

  @override
  String get settingsAbout => 'Tietoja';

  @override
  String get settingsPlaceholder => 'Tämä on väliaikainen asetukset-sivu.';

  @override
  String get settingsFutureWillInclude => 'Tulevat asetukset sisältävät:';

  @override
  String get settingsColorScheme => '• Väriteeman asetukset';

  @override
  String get settingsDefaultArrows => '• Nuolien oletusmäärät';

  @override
  String get settingsScoreInput => '• Pisteidenluonnin asetukset';

  @override
  String get settingsExportOptions => '• Vientiasetukset';

  @override
  String get settingsSessionManagement => '• Istunnon hallinta';

  @override
  String get dialogKeepScoresTitle => 'Säilytetäänkö pisteet?';

  @override
  String get devTodoLocalization =>
      'KORVAA KAIKKI NÄMÄ TEKSTIT LOKALISOINTIMERKINNÖILLÄ!!';
}
