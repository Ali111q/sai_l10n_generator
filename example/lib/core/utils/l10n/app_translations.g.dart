part of 'app_translations.dart';

class _AppTranslation implements AppTranslation {
@override
  Map<String, Map<String, String>> get keys => {
    'ar': Locales.ar,
    'en': Locales.en,
  };
}

class Locales {
  static const ar = {
    "hello": "",
    "welcomeMessage": "",
    "clickMe": "",
  };
  static const en = {
    'hello': '',
    'welcomeMessage': '',
    'clickMe': '',
  };
}
