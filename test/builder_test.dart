import 'dart:io';

import 'package:package_resolver/package_resolver.dart';
import 'package:r_flutter/builder.dart';
import 'package:test/test.dart';
import 'package:build_test/build_test.dart';

PackageAssetReader readerForExampleAssets() {
  Directory.current = Directory('example');

  final resolver = SyncPackageResolver.config({
    'example': Uri.file('lib'),
  });

  final reader = PackageAssetReader(resolver, 'example');
  return reader;
}

void main() {
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
}
