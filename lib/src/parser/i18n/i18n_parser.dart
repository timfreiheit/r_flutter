import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart';
import 'package:r_flutter/src/model/i18n.dart';
import 'package:r_flutter/src/parser/i18n/arb_parser.dart';

I18nLocales? parseStrings(String? defaultIntlFile) {
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

  final parser = I18nParser.all()
      .firstWhereOrNull((parser) => parser.supportsFile(intlFile));
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

List<I18nFeature>? parseFeatureStrings(
  String? defaultIntlFile,
  Map<String, String?> features,
) {
  if (defaultIntlFile == null || defaultIntlFile.isEmpty) {
    return null;
  }

  if (features.isEmpty) {
    return null;
  }

  final defaultFilename = basename(defaultIntlFile);

  return features.entries
      .map((e) {
        final name = e.key;
        final path = e.value;
        final directory = getDirectoryForFeature(name, path, defaultIntlFile);
        final locales = parseStrings(join(directory, defaultFilename));

        if (locales == null) {
          return null;
        }

        return I18nFeature(
          name: name,
          path: path,
          locales: locales,
        );
      })
      .where((e) => e != null)
      .cast<I18nFeature>()
      .toList();
}

String getDirectoryForFeature(
  String featureName,
  String? featurePath,
  String defaultIntlFile,
) {
  return featurePath != null
      ? Directory(featurePath).path
      : join(dirname(defaultIntlFile), featureName);
}

Locale? _localeFromFileName(File file) {
  final name = basenameWithoutExtension(file.path);
  if (RegExp(r'^[a-z]{2}$').hasMatch(name)) {
    return Locale(name);
  }
  if (RegExp(r'^[a-z]{2}_[A-Z]{2}$').hasMatch(name)) {
    final localeParts = name.split("_");
    return Locale(localeParts[0], localeParts[1]);
  }
  if (RegExp(r'^[a-z]{2}_[A-Z][a-z]{3}$').hasMatch(name)) {
    final localeParts = name.split("_");
    return Locale.fromSubtags(
      languageCode: localeParts[0],
      scriptCode: localeParts[1],
    );
  }
  if (RegExp(r'^[a-z]{2}_[A-Z][a-z]{3}_[A-Z]{2}$').hasMatch(name)) {
    final localeParts = name.split("_");
    return Locale.fromSubtags(
      languageCode: localeParts[0],
      scriptCode: localeParts[1],
      countryCode: localeParts[2],
    );
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
