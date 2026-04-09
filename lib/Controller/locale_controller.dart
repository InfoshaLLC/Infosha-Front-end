import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/Locales/es_es.dart';

import '../Locales/ar_sa.dart';
import '../Locales/en_us.dart';

class LocalizationService extends Translations {
  // Default locale
  // static final locale = Locale('ar', 'SA');
  static final locale = Locale('en', 'US');

  // fallbackLocale saves the day when the locale gets in trouble
  static final fallbackLocale = Locale('en', 'US');

  // Supported languages
  // Needs to be same order with locales
  static final langs = [
    'English',
    'Arabic',
  ];

  // Supported locales
  // Needs to be same order with langs
  static final locales = [
    Locale('en', 'US'),
    Locale('ar', 'SA'),
  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS, // lang/en_us.dart
        // 'ar_SA': arSA, // lang/tr_tr.dart
        'es_ES': esES, // lang/tr_tr.dart
      };

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) {
    final locale = _getLocaleFromLanguage(lang);
    Get.updateLocale(locale);
    Get.back();
  }

  // Finds language in `langs` list and returns it as Locale
  Locale _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale!;
  }
}
