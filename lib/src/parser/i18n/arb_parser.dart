import 'dart:convert';
import 'dart:io';

import 'package:r_flutter/src/model/i18n.dart';
import 'package:r_flutter/src/parser/i18n/i18n_parsing_utils.dart';
import 'package:r_flutter/src/parser/i18n/i18n_parser.dart';

class ArbI18nParser extends I18nParser {
  @override
  List<I18nString> parseFile(File file) {
    Map data = json.decode(file.readAsStringSync());

    List<I18nString> references = [];
    data.cast<String, dynamic>().forEach((key, value) {
      if (key.startsWith("@") || !(value is String)) {
        return;
      }
      references.add(I18nString(
        key: key,
        placeholders: findPlaceholders(value),
        value: value,
      ));
    });
    return references;
  }

  @override
  bool supportsFile(File file) {
    return file.path.endsWith(".arb");
  }
}
