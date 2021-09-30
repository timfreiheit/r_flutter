import 'package:r_flutter/src/model/resources.dart';
import 'package:r_flutter/src/utils/utils.dart';
import 'package:yaml/yaml.dart';

class Config {
  final String pubspecFilename;
  final List<String> ignoreAssets;
  final String? intlFilename;
  final List<CustomAssetType> assetClasses;

  Config._({
    required this.pubspecFilename,
    this.intlFilename,
    this.ignoreAssets = const [],
    this.assetClasses = const [],
  });

  factory Config.fromPubspec(YamlMap yaml) {
    const pubspecFilename = 'pubspec.yaml';

    final rFlutterConfig = safeCast<YamlMap>(yaml["r_flutter"]);
    if (rFlutterConfig == null) {
      return Config._(pubspecFilename: pubspecFilename);
    }

    final ignoreRaw = safeCast<YamlList>(rFlutterConfig['ignore']);
    final ignoreAssets = ignoreRaw
            ?.map((x) => safeCast<String>(x))
            .where((it) => it != null)
            .toList()
            .cast<String>() ??
        [];
    final intlFilename = safeCast<String>(rFlutterConfig['intl']);

    final assetClasses = safeCast<YamlMap>(rFlutterConfig['asset_classes']);
    final classes = <CustomAssetType>[];
    for (final key in assetClasses?.keys ?? []) {
      final keyString = safeCast<String>(key);
      if (keyString == null) {
        continue;
      }
      final dynamic value = assetClasses![key];
      var import = CustomAssetType.defaultImport;
      String className;
      if (value is YamlMap) {
        className = safeCast<String>(value['class'])!;
        import = safeCast<String>(value['import']) ?? import;
      } else if (value is String) {
        className = value;
      } else {
        throw StateError("Unsupported value (value = $value) in assetClasses!");
      }

      classes.add(CustomAssetType(className, keyString, import));
    }

    return Config._(
      pubspecFilename: pubspecFilename,
      ignoreAssets: ignoreAssets,
      intlFilename: intlFilename,
      assetClasses: classes,
    );
  }
}
