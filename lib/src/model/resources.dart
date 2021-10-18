import 'package:r_flutter/src/model/i18n.dart';

class Resources {
  final List<String> fonts;
  final Assets assets;
  final I18nLocales? i18n;
  final List<I18nFeature>? i18nFeatures;

  Resources({
    required this.fonts,
    required this.assets,
    this.i18n,
    this.i18nFeatures,
  });
}

class Assets {
  /// Actually found asset files
  final List<Asset> assets;

  /// Asset paths as declared in pubspec, minus the ignored ones
  final List<String> declared;

  const Assets(this.assets, this.declared);

  static const empty = Assets([], []);
}

class Asset {
  final String name;
  final String path;
  final String fileUri;
  final AssetType type;

  Asset({
    required this.name,
    required this.path,
    required this.fileUri,
    required this.type,
  });

  Asset copyWith({
    String? name,
    String? path,
    String? fileUri,
    AssetType? type,
  }) {
    return Asset(
        name: name ?? this.name,
        path: path ?? this.path,
        fileUri: fileUri ?? this.fileUri,
        type: type ?? this.type);
  }

  @override
  String toString() {
    return "Asset(name: $name, path: $path)";
  }

  @override
  bool operator ==(dynamic other) {
    return other is Asset && other.fileUri == fileUri;
  }

  @override
  int get hashCode => fileUri.hashCode;
}

class AssetType {
  final String key;

  const AssetType(this.key);

  static const image = AssetType('image');
  static const stringPath = AssetType('stringPath');
}

class CustomAssetType extends AssetType {
  final String extension;
  final String customClass;
  final String import;

  static const defaultImport = 'asset_classes.dart';

  const CustomAssetType(this.customClass, this.extension, this.import)
      : super(customClass);
}
