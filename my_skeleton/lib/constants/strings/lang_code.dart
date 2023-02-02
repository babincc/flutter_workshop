import 'package:my_skeleton/constants/strings/strings.dart';
import 'package:my_skeleton/constants/strings/strings_en.dart';

/// The language codes for each of the string packs.
enum LangCode {
  /// English
  en("en", StringsEN());

  const LangCode(this.value, this.strings);

  /// This [LangCode]'s string value.
  final String value;

  /// The strings associated with this [LangCode].
  final Strings strings;

  /// Get a [LangCode] from a given string `value`.
  static LangCode fromString(String value) {
    return values.firstWhere(
      (langCode) => langCode.value == value,
      orElse: () => LangCode.en,
    );
  }

  /// Get a [LangCode] from a given string pack.
  static LangCode fromStringPack(Strings strings) {
    return values.firstWhere(
      (langCode) => langCode.strings == strings,
      orElse: () => LangCode.en,
    );
  }
}
