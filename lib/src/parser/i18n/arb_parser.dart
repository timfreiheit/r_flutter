import 'dart:convert';
import 'dart:io';

import 'package:r_flutter/src/model/i18n.dart';
import 'package:r_flutter/src/parser/i18n/i18n_parsing_utils.dart';
import 'package:r_flutter/src/parser/i18n/i18n_parser.dart';
import 'package:r_flutter/src/utils/utils.dart';

class ArbI18nParser extends I18nParser {
  @override
  List<I18nString> parseFile(File file) {
    final data = safeCast<Map>(json.decode(file.readAsStringSync())) ?? {};

    final references = <I18nString>[];
    data.cast<String, dynamic>().forEach((key, value) {
      if (key.startsWith("@") || !(value is String)) {
        return;
      }
      final valueString = value as String;
      references.add(I18nString(
        key: key,
        placeholders: findPlaceholders(valueString),
        value: valueString,
      ));
    });
    return references;
  }

  @override
  bool supportsFile(File file) {
    return file.path.endsWith(".arb");
  }
}
