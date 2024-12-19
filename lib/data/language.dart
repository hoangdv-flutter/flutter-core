part of 'data.dart';

class SupportedLanguage {
  String name;
  String langCode;
  final String? _flagLangCode;

  SupportedLanguage(this.langCode, this.name, [this._flagLangCode]);

  String get flagLangCode => _flagLangCode ?? langCode;

  late final locale = langCode.split("-").length < 2
      ? Locale(langCode)
      : langCode.split('-').let(
            call: (value) => Locale(value[0], value[1]),
          );
}
