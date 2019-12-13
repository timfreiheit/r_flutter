import 'package:r_flutter/src/model/resources.dart';
import 'package:yaml/yaml.dart';

class Config {
  String pubspecFilename;
  List<String> ignoreAssets = [];
  String intlFilename;
  List<CustomAssetType> assetClasses = [];

  static Config parsePubspecConfig(YamlMap yaml) {
    final arguments = Config()
      ..pubspecFilename = 'pubspec.yaml';

    yaml = yaml["r_flutter"];
    if (yaml == null) {
      return arguments;
    }

    final YamlList ignoreRaw = yaml['ignore'];
    arguments.ignoreAssets = ignoreRaw?.map((x) => x as String)?.toList() ?? [];
    arguments.intlFilename = yaml['intl'];

    final YamlMap assetClasses = yaml['asset_classes'];
    final classes = <CustomAssetType>[];
    for (var key in assetClasses?.keys ?? []) {
      final Object value = assetClasses[key];
      var import = CustomAssetType.defaultImport;
      String className;
      if (value is YamlMap) {
        className = value['class'];
        import = value['import'] ?? import;
      } else if (value is String) {
        className = value;
      } else {
        assert(false);
      }

      classes.add(CustomAssetType(className, key, import));
    }
    arguments.assetClasses = classes;

    return arguments;
  }
}
