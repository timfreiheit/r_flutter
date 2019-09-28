import 'package:r_flutter/src/generator/generator.dart';
import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/resources.dart';

List<DartClass> generateAssetsClass(List<Asset> assets) {
  return [
    _generateAssetConstantsClass(
        assets.where((item) => item.type != AssetType.image).toList()),
    _generateImageAssetsClass(
        assets.where((item) => item.type == AssetType.image).toList())
  ];
}

DartClass _generateAssetConstantsClass(List<Asset> assets) {
  if (assets.length == 0) {
    return null;
  }
  String classString = "class Assets {\n";
  for (var asset in assets) {
    classString += createComment(asset);

    final custom = asset.type.customClass;
    if (custom != null) {
      classString +=
          "  static const $custom ${createVariableName(asset.name)} = $custom(\"${asset.path}\");\n";
    } else {
      classString +=
          "  static const String ${createVariableName(asset.name)} = \"${asset.path}\";\n";
    }
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
    classString += createComment(asset);
    classString +=
        "  static AssetImage get ${createVariableName(asset.name)} => const AssetImage(\"${asset.path}\");\n";
  }
  classString += "}\n";
  return DartClass(
    imports: ["package:flutter/widgets.dart"],
    code: classString,
  );
}

bool isExample;

String createComment(Asset asset) {
  String path = asset.fileUri;

  const examplePath = 'r_flutter/example/';

  if (isExample == null) {
    isExample = path.contains(examplePath);
  }

  // a hack to prevent commited assets.dart from changing constantly
  if (isExample) {
    path = path.substring(path.indexOf(examplePath) + examplePath.length);
    path = 'file:///Users/user/path/$path';
  }

  return "  /// ![]($path)\n";
}
