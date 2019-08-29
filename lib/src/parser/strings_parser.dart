import 'dart:convert';
import 'dart:io';

import 'package:r_flutter/src/model/resources.dart';

List<StringReference> parseStrings(String arbFilepath) {
  if (arbFilepath == null || arbFilepath.isEmpty) {
    return [];
  }
  File arbFile = File(arbFilepath);
  if (!arbFile.existsSync()) {
    return [];
  }
  Map data = json.decode(arbFile.readAsStringSync());

  List<StringReference> references = [];
  data.cast<String, dynamic>().forEach((key, value) {
    if (key.startsWith("@") || !(value is String)) {
      return;
    }
    references.add(StringReference(
      name: key,
      placeholders: _findPlaceholders(value),
      value: value,
    ));
  });
  return references;
}

List<String> _findPlaceholders(String value) {
  return RegExp(r"{[a-zA-Z0-9]+}")
      .allMatches(value)
      .map((item) => item.group(0).replaceAll("{", "").replaceAll("}", ""))
      .toList();
}
