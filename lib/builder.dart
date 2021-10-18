import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart';
import 'package:r_flutter/src/model/i18n.dart';
import 'package:r_flutter/src/parser/i18n/i18n_parser.dart';
import 'package:r_flutter/src/utils/utils.dart';
import 'package:yaml/yaml.dart';

import 'src/arguments.dart';
import 'src/generator/generator.dart';
import 'src/model/resources.dart';
import 'src/parser/assets_parser.dart';
import 'src/parser/fonts_parser.dart';

Resources parseResources(Config arguments) {
  final pubspecFile = File(arguments.pubspecFilename).absolute;
  if (!pubspecFile.existsSync()) {
    exit(1);
  }

  final yaml = loadYaml(pubspecFile.readAsStringSync()) as YamlMap;

  final primaryLocales = parseStrings(arguments.intlFilename);
  final featureLocales =
      parseFeatureStrings(arguments.intlFilename, arguments.i18nFeatures);

  if (primaryLocales != null && featureLocales != null) {
    // Make sure feature-only locales are added to the primary locale list.
    final featureOnlyLocales = <Locale>[];
    for (final feature in featureLocales) {
      for (final locale in feature.locales.locales) {
        if (!primaryLocales.locales.any((e) => e.locale == locale.locale)) {
          featureOnlyLocales.add(locale.locale);
        }
      }
    }

    if (featureOnlyLocales.isNotEmpty) {
      primaryLocales.locales
          .addAll(featureOnlyLocales.map((e) => I18nLocale(e, [])));
    }
  }

  return Resources(
    fonts: parseFonts(yaml),
    assets: parseAssets(yaml, arguments.ignoreAssets, arguments.assetClasses),
    i18n: primaryLocales,
    i18nFeatures: featureLocales,
  );
}

class AssetsBuilder extends Builder {
  /// This is needed to let build system know that we depend on given file
  Future<void> check(BuildStep buildStep, String? filename) async {
    if (filename == null) {
      return;
    }
    await buildStep.canRead(AssetId(buildStep.inputId.package, filename));
  }

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    log.info('processing: ${buildStep.inputId}');

    final input = buildStep.inputId;

    final output = AssetId(input.package, 'lib/assets.dart');

    final configId = AssetId(input.package, 'pubspec.yaml');

    final configRaw =
        safeCast<YamlMap>(loadYaml(await buildStep.readAsString(configId)));
    final config = Config.fromPubspec(configRaw ?? YamlMap());

    await _markIntlFiles(buildStep, config);

    await check(buildStep, config.intlFilename);
    await check(buildStep, config.pubspecFilename);
    final res = parseResources(config);

    for (final decl in res.assets.declared) {
      if (decl.endsWith('/')) {
        final glob = Glob('$decl*');
        final files = await buildStep.findAssets(glob).toList();
        log.finest('$glob $files');
      }
    }

    final generated = generateFile(res, config);
    await buildStep.writeAsString(output, generated);
  }

  ///
  /// mark intl files to the BuildStep to update the code generation when one of the files changes
  ///
  Future<void> _markIntlFiles(BuildStep buildStep, Config arguments) async {
    final intlFilename = arguments.intlFilename;
    if (intlFilename == null) {
      return;
    }
    final path = intlFilename.replaceAll(basename(intlFilename), "");
    final glob = Glob('$path*');
    final files = await buildStep.findAssets(glob).toList();
    for (final file in files) {
      buildStep.canRead(file);
    }

    arguments.i18nFeatures.forEach((name, path) async {
      final directory = getDirectoryForFeature(name, path, intlFilename);
      final featureGlob = Glob(join(directory, '*'));
      final featureFiles = await buildStep.findAssets(featureGlob).toList();
      for (final file in featureFiles) {
        buildStep.canRead(file);
      }
    });
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r"$lib$": ["assets.dart"],
      };
}

Builder builder(BuilderOptions builderOptions) {
  log.info('creating AssetsBuilder');
  return AssetsBuilder();
}
