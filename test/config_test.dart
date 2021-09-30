import 'package:r_flutter/src/arguments.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  test("test parse empty yaml to config", () {
    final config = Config.fromPubspec(YamlMap());
    expect(config, isNotNull);
    expect(config.pubspecFilename, "pubspec.yaml");
    expect(config.assetClasses, []);
    expect(config.ignoreAssets, []);
    expect(config.intlFilename, isNull);
  });

  test("test parse asset classes to config", () {
    final config = Config.fromPubspec(loadYaml("""
r_flutter:
  asset_classes:
    ".svg": 
      import: asset_classes.dart
      class: SvgFile
    """) as YamlMap);
    expect(config, isNotNull);
    expect(config.pubspecFilename, "pubspec.yaml");
    expect(config.assetClasses, hasLength(1));
    expect(config.assetClasses[0].extension, ".svg");
    expect(config.assetClasses[0].import, "asset_classes.dart");
    expect(config.assetClasses[0].customClass, "SvgFile");
    expect(config.ignoreAssets, []);
    expect(config.intlFilename, isNull);
  });

  test("test parse multiple asset classes to config", () {
    final config = Config.fromPubspec(loadYaml("""
r_flutter:
  asset_classes:
    ".svg": 
      import: abc.dart
      class: SvgFile
    ".txt": 
      class: String
    ".txt2": String
    """) as YamlMap);
    expect(config, isNotNull);
    expect(config.pubspecFilename, "pubspec.yaml");
    expect(config.assetClasses, hasLength(3));

    expect(config.assetClasses[0].extension, ".svg");
    expect(config.assetClasses[0].import, "abc.dart");
    expect(config.assetClasses[0].customClass, "SvgFile");

    expect(config.assetClasses[1].extension, ".txt");
    expect(config.assetClasses[1].import, "asset_classes.dart");
    expect(config.assetClasses[1].customClass, "String");

    expect(config.assetClasses[2].extension, ".txt2");
    expect(config.assetClasses[2].import, "asset_classes.dart");
    expect(config.assetClasses[2].customClass, "String");

    expect(config.ignoreAssets, []);
    expect(config.intlFilename, isNull);
  });
  test("test parse intl file to config", () {
    final config = Config.fromPubspec(loadYaml("""
r_flutter:
  intl: lib/i18n/en.arb
    """) as YamlMap);
    expect(config, isNotNull);
    expect(config.pubspecFilename, "pubspec.yaml");
    expect(config.assetClasses, []);
    expect(config.ignoreAssets, []);
    expect(config.intlFilename, "lib/i18n/en.arb");
  });

  test("test parse ignored assets to config", () {
    final config = Config.fromPubspec(loadYaml("""
r_flutter:
  ignore:
    - lib/assets/sub/ignore1
    - lib/assets/sub/ignore2
    - lib/i18n
    """) as YamlMap);
    expect(config, isNotNull);
    expect(config.pubspecFilename, "pubspec.yaml");
    expect(config.assetClasses, []);
    expect(
      config.ignoreAssets,
      ["lib/assets/sub/ignore1", "lib/assets/sub/ignore2", "lib/i18n"],
    );
    expect(config.intlFilename, isNull);
  });

  test("test combined config to config", () {
    final config = Config.fromPubspec(loadYaml("""
r_flutter:
  asset_classes:
    ".svg": SvgFile
  intl: lib/de.arb
  ignore:
    - lib/i18n
    """) as YamlMap);
    expect(config, isNotNull);
    expect(config.pubspecFilename, "pubspec.yaml");
    expect(config.assetClasses, hasLength(1));

    expect(config.assetClasses[0].extension, ".svg");
    expect(config.assetClasses[0].import, "asset_classes.dart");
    expect(config.assetClasses[0].customClass, "SvgFile");

    expect(config.ignoreAssets, ["lib/i18n"]);
    expect(config.intlFilename, "lib/de.arb");
  });
}
