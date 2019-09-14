import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:r_flutter/src/model/resources.dart';

Assets parseAssets(yaml, List<String> ignoreAssets) {
  final flutter = yaml["flutter"];
  if (flutter == null) {
    return Assets.empty;
  }

  List assets = flutter["assets"];
  if (assets == null) {
    return Assets.empty;
  }

  Set<String> assetFiles = Set();
  List<String> declared = [];
  for (String asset in assets) {
    if (assetShouldBeIgnored(asset, ignoreAssets)) {
      continue;
    }
    declared.add(asset);
    assetFiles.addAll(_findFiles(asset, ignoreAssets));
  }
  return Assets(_convertToAssets(assetFiles.toList()), declared);
}

bool assetShouldBeIgnored(String path, List<String> ignoreAssets) {
  return ignoreAssets.any((item) => path.startsWith(item))
    || path.endsWith(".DS_Store");
}

List<String> _findFiles(String asset, List<String> ignoreAssets) {
  switch (FileSystemEntity.typeSync(asset)) {
    case FileSystemEntityType.file:
      return [asset];
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
                return entry.path;
              }
              return null;
            })
            .where((it) => it != null)
            .toList();
      }
    default:
      return [];
  }
}

AssetType _findAssetTypeFromPath(String pathString) {
  switch (path.extension(pathString).toLowerCase()) {
    case ".png":
    case ".jpg":
    case ".gif":
      return AssetType.IMAGE;
    default:
      return AssetType.OTHER;
  }
}

List<Asset> _convertToAssets(List<String> assetPaths) {
  List<Asset> rawAssets = assetPaths
      .map((pathString) => Asset(
            name: path.basenameWithoutExtension(pathString),
            path: pathString,
            type: _findAssetTypeFromPath(pathString),
          ))
      .toList();

  List<Asset> assets = [];
  for (var asset in rawAssets) {
    if (assets.any((item) => item.path == asset.path)) {
      // asset already added
      continue;
    }

    var duplicateNames =
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
    for (var item in list) {
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
        newName = path.basenameWithoutExtension(item.second.path) +
            "_" +
            item.first.name;
        newParentDir = item.second.parent;
      }
      return _Pair(
          Asset(name: newName, path: item.first.path, type: item.first.type),
          newParentDir);
    }).toList();
  }
  return list.map((item) => item.first).toList();
}

class _Pair<T, S> {
  final T first;
  final S second;

  _Pair(this.first, this.second);
}
