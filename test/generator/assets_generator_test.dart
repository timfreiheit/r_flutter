import 'package:r_flutter/src/generator/assets_generator.dart';
import 'package:r_flutter/src/model/resources.dart';
import 'package:test/test.dart';

void main() {
  test("test single simple asset", () {
    final result = generateAssetsClass([
      Asset(
          name: "file",
          path: "lib/path/file.txt",
          fileUri: "file:///Users/user/path/lib/path/file.txt",
          type: AssetType.stringPath)
    ]);
    expect(result.length, 1);
    expect(result[0].imports, []);
    expect(result[0].code, """class Assets {
  /// ![](lib/path/file.txt)
  static const String file = "lib/path/file.txt";
}
""");
  });

  test("test single simple image asset", () {
    final result = generateAssetsClass([
      Asset(
          name: "file",
          path: "lib/path/file.png",
          fileUri: "file:///Users/user/path/lib/path/file.png",
          type: AssetType.image)
    ]);
    expect(result.length, 1);
    expect(result[0].imports, ['package:flutter/widgets.dart']);
    expect(result[0].code, """class Images {
  /// ![](lib/path/file.png)
  static AssetImage get file => const AssetImage("lib/path/file.png");
}
""");
  });

  test("test custom asset type", () {
    final result = generateAssetsClass([
      Asset(
        name: "file",
        path: "lib/path/file.svg",
        fileUri: "file:///Users/user/path/lib/path/file.svg",
        type: const CustomAssetType(
          "SvgFile",
          ".svg",
          "asset_classes.dart",
        ),
      )
    ]);
    expect(result.length, 1);
    expect(result[0].imports, ['asset_classes.dart']);
    expect(result[0].code, """class Assets {
  /// ![](lib/path/file.svg)
  static const SvgFile file = SvgFile("lib/path/file.svg");
}
""");
  });

  test("test multiple simple assets", () {
    final result = generateAssetsClass([
      Asset(
        name: "file",
        path: "lib/path/file.txt",
        fileUri: "file:///Users/user/path/lib/path/file.txt",
        type: AssetType.stringPath,
      ),
      Asset(
        name: "file2",
        path: "lib/path/file2.txt",
        fileUri: "file:///Users/user/path/lib/path/file.txt",
        type: AssetType.stringPath,
      ),
      Asset(
        name: "image",
        path: "lib/path/file.png",
        fileUri: "file:///Users/user/path/lib/path/image.png",
        type: AssetType.image,
      ),
      Asset(
        name: "image2",
        path: "lib/path/image2.png",
        fileUri: "file:///Users/user/path/lib/path/image2.png",
        type: AssetType.image,
      ),
      Asset(
        name: "svgfile",
        path: "lib/path/svgfile.svg",
        fileUri: "file:///Users/user/path/lib/path/svgfile.svg",
        type: const CustomAssetType(
          "SvgFile",
          ".svg",
          "asset_classes.dart",
        ),
      )
    ]);
    expect(result.length, 2);
    expect(result[0].imports, ['asset_classes.dart']);
    expect(result[0].code, """class Assets {
  /// ![](lib/path/file.txt)
  static const String file = "lib/path/file.txt";
  /// ![](lib/path/file2.txt)
  static const String file2 = "lib/path/file2.txt";
  /// ![](lib/path/svgfile.svg)
  static const SvgFile svgfile = SvgFile("lib/path/svgfile.svg");
}
""");

    expect(result[1].imports, ['package:flutter/widgets.dart']);
    expect(result[1].code, """class Images {
  /// ![](lib/path/file.png)
  static AssetImage get image => const AssetImage("lib/path/file.png");
  /// ![](lib/path/image2.png)
  static AssetImage get image2 => const AssetImage("lib/path/image2.png");
}
""");
  });
}
