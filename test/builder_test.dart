import 'dart:io';

import 'package:package_resolver/package_resolver.dart';
import 'package:r_flutter/builder.dart';
import 'package:test/test.dart';
import 'package:build_test/build_test.dart';
import 'package:path/path.dart' as p;

PackageAssetReader readerForExampleAssets() {
  final path = p.join(Directory.current.path, 'example', 'lib');

  final resolver = SyncPackageResolver.config({
    'example': Uri.file(path),
  });

  final reader = PackageAssetReader(resolver, 'example');
  return reader;
}

void main() {
  group('test AssetsBuilder', () {
    test('test assets.dart created', () async {
      final builder = AssetsBuilder();

      await testBuilder(
        builder,
        {
          'example|lib/assets.yaml': null,
        },
        outputs: {
          'example|lib/assets.dart': isNotNull,
        },
        reader: readerForExampleAssets(),
      );
    });

    test('test empty assets.yaml file', () async {
      final builder = AssetsBuilder();

      await testBuilder(
        builder,
        {
          'example|lib/assets.yaml': '',
        },
        outputs: {
          'example|lib/assets.dart': '',
        },
      );
    });

    test('test no assets.yaml file', () async {
      final builder = AssetsBuilder();

      await testBuilder(builder, {}, outputs: {});
    });
  });
}
