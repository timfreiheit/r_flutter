class Resources {
  final List<String> fonts;
  final Assets assets;
  final List<StringReference> stringReferences;

  Resources({
    this.fonts,
    this.assets,
    this.stringReferences,
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
  final AssetType type;

  Asset({
    this.name,
    this.path,
    this.type,
  });

  @override
  String toString() {
    return "Asset(name: $name, path: $path)";
  }
}

enum AssetType { IMAGE, OTHER }

class StringReference {
  final String name;
  final List<String> placeholders;
  final String value;

  StringReference({
    this.name,
    this.placeholders,
    this.value,
  });
}
