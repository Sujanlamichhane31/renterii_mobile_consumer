import 'package:renterii/Locale/arabic.dart';
import 'package:renterii/Locale/english.dart';
import 'package:renterii/Locale/french.dart';
import 'package:renterii/Locale/german.dart';
import 'package:renterii/Locale/indonesian.dart';
import 'package:renterii/Locale/italian.dart';
import 'package:renterii/Locale/portuguese.dart';
import 'package:renterii/Locale/romanian.dart';
import 'package:renterii/Locale/spanish.dart';
import 'package:renterii/Locale/swahili.dart';
import 'package:renterii/Locale/turkish.dart';

class AppConfig {
  static final String appName = "Hungerz";
  static final bool isDemoMode = false;
  static const String languageDefault = "en";
  // static final Map<String, AppLanguage> languagesSupported = {
  //   "en": AppLanguage("English", english()),
  //   "ar": AppLanguage("عربى", arabic()),
  //   "pt": AppLanguage("Portugal", portuguese()),
  //   "fr": AppLanguage("Français", french()),
  //   "id": AppLanguage("Bahasa Indonesia", indonesian()),
  //   "es": AppLanguage("Español", spanish()),
  //   "it": AppLanguage("italiano", italian()),
  //   "tr": AppLanguage("Türk", turkish()),
  //   "sw": AppLanguage("Kiswahili", swahili()),
  //   "de": AppLanguage("Deutsch", german()),
  //   "ro": AppLanguage("Română", romanian()),
  // };
  static final Map<String, AppLanguage> languagesSupported = {
    "en": AppLanguage("English", english()),
    // "ar": AppLanguage("عربى", arabic()),
    // "pt": AppLanguage("Portugal", portuguese()),
    "fr": AppLanguage("Français", french()),
    // "id": AppLanguage("Bahasa Indonesia", indonesian()),
    "es": AppLanguage("Español", spanish()),
    // "it": AppLanguage("italiano", italian()),
    // "tr": AppLanguage("Türk", turkish()),
    // "sw": AppLanguage("Kiswahili", swahili()),
    "de": AppLanguage("Deutsch", german()),
    // "ro": AppLanguage("Română", romanian()),
  };
}

class AppLanguage {
  final String name;
  final Map<String, String> values;
  AppLanguage(this.name, this.values);
}
