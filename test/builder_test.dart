import 'package:package_resolver/package_resolver.dart';
import 'package:r_flutter/builder.dart';
import 'package:test/test.dart';
import 'package:build_test/build_test.dart';

PackageAssetReader readerForExampleAssets() {
  final resolver = SyncPackageResolver.config({
    'example': Uri.file('example'),
  });

  final reader = PackageAssetReader(resolver, 'example');
  return reader;
}

void main() {
  test('test assets.dart created', () async {
    final builder = AssetsAndFontsBuilder();

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
