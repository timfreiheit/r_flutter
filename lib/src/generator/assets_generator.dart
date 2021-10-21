import 'package:r_flutter/src/generator/generator.dart';
import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/resources.dart';

List<DartClass> generateAssetsClass(List<Asset> assets) {
  return [
    _generateAssetConstantsClass(
        assets.where((item) => item.type != AssetType.image).toList()),
    _generateImageAssetsClass(
        assets.where((item) => item.type == AssetType.image).toList())
  ].where((it) => it != null).toList().cast<DartClass>();
}

DartClass? _generateAssetConstantsClass(List<Asset> assets) {
  if (assets.isEmpty) {
    return null;
  }

  final imports = <String>{};

  final classString = StringBuffer("class Assets {\n");
  for (final asset in assets) {
    classString.write(createComment(asset));

    final type = asset.type;
    if (type is CustomAssetType) {
      imports.add(type.import);
      final custom = type.customClass;
      classString.writeln(
          "  static const $custom ${createVariableName(asset.name)} = $custom(\"${asset.path}\");");
    } else {
      classString.writeln(
          "  static const String ${createVariableName(asset.name)} = \"${asset.path}\";");
    }
  }
  classString.writeln("}");
  return DartClass(
      code: classString.toString(), imports: imports.toList()..sort());
}

DartClass? _generateImageAssetsClass(List<Asset> assets) {
  if (assets.isEmpty) {
    return null;
  }
  final classString = StringBuffer("class Images {\n");
  for (final asset in assets) {
    classString.write(createComment(asset));
    classString.writeln(
        "  static AssetImage get ${createVariableName(asset.name)} => const AssetImage(\"${asset.path}\");");
  }
  classString.writeln("}");
  return DartClass(
    imports: ["package:flutter/widgets.dart"],
    code: classString.toString(),
  );
}

bool? isExample;

String createComment(Asset asset) {
  final path = asset.path;
  return "  /// ![]($path)\n";
}
