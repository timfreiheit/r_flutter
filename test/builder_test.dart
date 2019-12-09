import 'dart:io';

import 'package:package_resolver/package_resolver.dart';
import 'package:r_flutter/builder.dart';
import 'package:test/test.dart';
import 'package:build_test/build_test.dart';
import 'package:path/path.dart' as p;

import 'current_directory.dart';

PackageAssetReader readerForExampleAssets() {
  setCurrentDirectory(savedCurrentDirectory.path + '/example');

  final path = p.join(Directory.current.path, 'lib');

  final resolver = SyncPackageResolver.config({
    'example': Uri.file(path),
  });

  final reader = PackageAssetReader(resolver, 'example');
  return reader;
}

class ContainsString extends Matcher {
  final String value;

  ContainsString(this.value);

  @override
  Description describe(Description description) {
    return description;
  }

  @override
  bool matches(item, Map matchState) {
    List<int> bytes = item;
    final string = String.fromCharCodes(bytes);
    return string.contains(value);
  }
}

void main() {
  group('test AssetsBuilder', () {
    test('test assets.dart created', () async {
      final builder = AssetsBuilder();

      await testBuilder(
        builder,
        {
          'example|lib/main.dart': '',
        },
        outputs: {
          'example|lib/assets.dart': ContainsString('Assets'),
        },
        reader: readerForExampleAssets(),
      );
    });

    test('test empty pubspec.yaml file', () async {
      setCurrentDirectory(savedCurrentDirectory.path);
      final builder = AssetsBuilder();

      await testBuilder(
        builder,
        {
          'example|lib/main.dart': '',
          'example|pubspec.yaml': '',
        },
        outputs: {
          'example|lib/assets.dart': '',
        },
      );
    });
  });
  setCurrentDirectory(null);
}
