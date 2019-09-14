import 'package:r_flutter/src/generator/generator.dart';
import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/resources.dart';

List<DartClass> generateAssetsClass(List<Asset> assets) {
  return [
    _generateAssetConstantsClass(
        assets.where((item) => item.type == AssetType.OTHER).toList()),
    _generateImageAssetsClass(
        assets.where((item) => item.type == AssetType.IMAGE).toList())
  ];
}

DartClass _generateAssetConstantsClass(List<Asset> assets) {
  if (assets.length == 0) {
    return null;
  }
  String classString = "class Assets {\n";
  for (var asset in assets) {
    classString +=
        "  /// ![](${asset.fileUri})\n";
    classString +=
        "  static const String ${createVariableName(asset.name)} = \"${asset.path}\";\n";
  }
  classString += "}\n";
  return DartClass(code: classString);
}

DartClass _generateImageAssetsClass(List<Asset> assets) {
  if (assets.length == 0) {
    return null;
  }
  String classString = "class Images {\n";
  for (var asset in assets) {
    classString +=
        "  /// ![](${asset.fileUri})\n";
    classString +=
        "  static AssetImage get ${createVariableName(asset.name)} => const AssetImage(\"${asset.path}\");\n";
  }
  classString += "}\n";
  return DartClass(
    imports: ["package:flutter/widgets.dart"],
    code: classString,
  );
}
