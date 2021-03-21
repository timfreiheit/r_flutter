import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:r_flutter/src/model/resources.dart';
import 'package:r_flutter/src/utils/utils.dart';
import 'package:yaml/yaml.dart';

Assets parseAssets(YamlMap yaml, List<String> ignoreAssets,
    List<CustomAssetType> assetClasses) {
  final flutter = yaml["flutter"];
  if (flutter == null) {
    return Assets.empty;
  }

  final assets = safeCast<List>(flutter["assets"]);
  if (assets == null) {
    return Assets.empty;
  }

  final assetFiles = <File>{};
  final declared = <String>[];
  for (final asset in assets) {
    if (asset is String) {
      if (assetShouldBeIgnored(asset, ignoreAssets)) {
        continue;
      }
      declared.add(asset);
      assetFiles.addAll(_findFiles(asset, ignoreAssets));
    }
  }

  final files = assetFiles.toList();
  files.sort((lhs, rhs) => lhs.path.compareTo(rhs.path));

  return Assets(_convertToAssets(files, assetClasses), declared);
}

bool assetShouldBeIgnored(String path, List<String> ignoreAssets) {
  return ignoreAssets.any((item) => path.startsWith(item)) ||
      path.endsWith(".DS_Store");
}

List<File> _findFiles(String asset, List<String> ignoreAssets) {
  switch (FileSystemEntity.typeSync(asset)) {
    case FileSystemEntityType.file:
      return [File(asset)];
    case FileSystemEntityType.directory:
      {
        final dir = Directory(asset);
        return dir
            .listSync()
            .map((entry) {
              final entryType = FileSystemEntity.typeSync(entry.path);
              if (entryType == FileSystemEntityType.file) {
                if (assetShouldBeIgnored(entry.path, ignoreAssets)) {
                  return null;
                }
                return File(entry.path);
              }
              return null;
            })
            .where((it) => it != null)
            .toList()
            .cast<File>();
      }
    default:
      return [];
  }
}

AssetType _findAssetTypeFromPath(
    String pathString, List<CustomAssetType>? assetClasses) {
  if (assetClasses != null) {
    for (final obj in assetClasses) {
      if (pathString.endsWith(obj.extension)) {
        return obj;
      }
    }
  }

  switch (path.extension(pathString).toLowerCase()) {
    case ".png":
    case ".jpg":
    case ".gif":
      return AssetType.image;
    default:
      return AssetType.stringPath;
  }
}

List<Asset> _convertToAssets(
    List<File> assetFiles, List<CustomAssetType> assetClasses) {
  final rawAssets = assetFiles
      .map((file) => Asset(
            name: path.basenameWithoutExtension(file.path),
            path: file.path,
            fileUri: file.absolute.uri.toString(),
            type: _findAssetTypeFromPath(file.path, assetClasses),
          ))
      .toSet();

  final assets = <Asset>[];
  for (final asset in rawAssets) {
    if (assets.any((item) => item.path == asset.path)) {
      // asset already added
      continue;
    }

    final duplicateNames =
        rawAssets.where((item) => item.name == asset.name).toList();
    if (duplicateNames.length == 1) {
      // no duplicates found
      assets.add(asset);
      continue;
    }

    assets.addAll(specifyAssetNames(duplicateNames));
  }

  return assets;
}

List<Asset> specifyAssetNames(List<Asset> assets) {
  bool containsDuplicates(List<_Pair<Asset, Directory>> list) {
    for (final item in list) {
      if (list.any((item2) {
        if (item == item2) {
          return false;
        }
        return item.first.name == item2.first.name;
      })) {
        return true;
      }
    }
    return false;
  }

  var list = assets.map((item) => _Pair(item, File(item.path).parent)).toList();

  int iteration = 0;
  while (iteration < 5 && containsDuplicates(list)) {
    iteration++;
    list = list.map((item) {
      var newName = item.first.name;
      var newParentDir = item.second;
      if (item.second.path != ".") {
        newName =
            "${path.basenameWithoutExtension(item.second.path)}_${item.first.name}";
        newParentDir = item.second.parent;
      }
      return _Pair(item.first.copyWith(name: newName), newParentDir);
    }).toList();
  }
  return list.map((item) => item.first).toList();
}

class _Pair<T, S> {
  final T first;
  final S second;

  _Pair(this.first, this.second);
}
