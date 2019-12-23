import 'dart:io';

import 'package:r_flutter/src/model/i18n.dart';
import 'package:r_flutter/src/parser/i18n/arb_parser.dart';
import 'package:path/path.dart';

I18nLocales parseStrings(String defaultIntlFile) {
  if (defaultIntlFile == null || defaultIntlFile.isEmpty) {
    return null;
  }
  final intlFile = File(defaultIntlFile);
  if (!intlFile.existsSync()) {
    return null;
  }

  final defaultLocale = _localeFromFileName(intlFile);
  if (defaultLocale == null) {
    return null;
  }

  final parser =
      I18nParser.all().firstWhere((parser) => parser.supportsFile(intlFile));
  if (parser == null) {
    return null;
  }

  final locales = <I18nLocale>[];
  final files = intlFile.parent.listSync();
  for (final file in files) {
    if (file is File) {
      if (!parser.supportsFile(file)) {
        continue;
      }
      final locale = _localeFromFileName(file);
      if (locale == null) {
        continue;
      }
      locales.add(I18nLocale(locale, parser.parseFile(file)));
    }
  }

  return I18nLocales(defaultLocale, locales);
}

Locale _localeFromFileName(File file) {
  final name = basenameWithoutExtension(file.path);
  if (RegExp(r'^[a-z]{2}$').hasMatch(name)) {
    return Locale(name, null);
  }
  if (RegExp(r'^[a-z]{2}_[A-Z]{2}$').hasMatch(name)) {
    final localeParts = name.split("_");
    return Locale(localeParts[0], localeParts[1]);
  }
  return null;
}

abstract class I18nParser {
  bool supportsFile(File file);
  List<I18nString> parseFile(File file);

  static List<I18nParser> all() {
    return [ArbI18nParser()];
  }
}
