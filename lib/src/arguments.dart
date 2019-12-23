import 'package:r_flutter/src/model/resources.dart';
import 'package:r_flutter/src/utils/utils.dart';
import 'package:yaml/yaml.dart';

class Config {
  String pubspecFilename;
  List<String> ignoreAssets = [];
  String intlFilename;
  List<CustomAssetType> assetClasses = [];

  Config();

  factory Config.parsePubspecConfig(YamlMap yaml) {
    final arguments = Config()..pubspecFilename = 'pubspec.yaml';

    final rFlutterConfig = safeCast<YamlMap>(yaml["r_flutter"]);
    if (rFlutterConfig == null) {
      return arguments;
    }

    final ignoreRaw = safeCast<YamlList>(rFlutterConfig['ignore']);
    arguments.ignoreAssets = ignoreRaw
            ?.map((x) => safeCast<String>(x))
            ?.where((it) => it != null)
            ?.toList() ??
        [];
    arguments.intlFilename = safeCast<String>(rFlutterConfig['intl']);

    final assetClasses = safeCast<YamlMap>(rFlutterConfig['asset_classes']);
    final classes = <CustomAssetType>[];
    for (final key in assetClasses?.keys ?? []) {
      final keyString = safeCast<String>(key);
      if (keyString == null) {
        continue;
      }
      final Object value = assetClasses[key];
      var import = CustomAssetType.defaultImport;
      String className;
      if (value is YamlMap) {
        className = safeCast<String>(value['class']);
        import = safeCast<String>(value['import']) ?? import;
      } else if (value is String) {
        className = value;
      } else {
        assert(false);
      }

      classes.add(CustomAssetType(className, keyString, import));
    }
    arguments.assetClasses = classes;

    return arguments;
  }
}
