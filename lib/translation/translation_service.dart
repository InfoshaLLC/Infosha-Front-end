import 'package:get/get.dart';
import 'package:infosha/translation/ar.dart';
import 'package:infosha/translation/en.dart';
import 'package:infosha/translation/fr.dart';

class TranslationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': englishLanguage(),
        'ar': arabicLanguage(),
        'fr': frenchLanguage(),
      };
}
