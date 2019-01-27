class Resources {
  final List<String> fonts;
  final List<Asset> assets;
  final List<StringReference> stringReferences;

  Resources({
    this.fonts,
    this.assets,
    this.stringReferences,
  });
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
