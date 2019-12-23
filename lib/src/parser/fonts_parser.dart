import 'package:r_flutter/src/utils/utils.dart';
import 'package:yaml/yaml.dart';

List<String> parseFonts(YamlMap yaml) {
  final flutter = yaml["flutter"];
  if (flutter == null) {
    return [];
  }

  final fonts = safeCast<List>(flutter["fonts"]);
  if (fonts == null) {
    return [];
  }

  return fonts
      .map((item) => safeCast<String>(item["family"]))
      .where((it) => it != null)
      .toList();
}
