import 'package:get/get.dart';

import 'english.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys =>
      {LanguageConstants.english: english};
}

class LanguageConstants {
  static String english = "en_IN";
}
