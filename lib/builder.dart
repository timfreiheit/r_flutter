import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'src/arguments.dart';
import 'src/generator/generator.dart';
import 'src/model/resources.dart';
import 'src/parser/assets_parser.dart';
import 'src/parser/fonts_parser.dart';
import 'src/parser/strings_parser.dart';

String generate(Arguments arguments) {
  final pubspecFile = File(arguments.pubspecFilename).absolute;
  if (!pubspecFile.existsSync()) {
    print("pubspec file does not exists: " + pubspecFile.path);
    exit(1);
  }

  final yaml = loadYaml(pubspecFile.readAsStringSync());
  final res = Resources(
      fonts: parseFonts(yaml),
      assets: parseAssets(yaml, arguments.ignoreAssets),
      stringReferences: parseStrings(arguments.intlFilename));

  return generateFile(res);
}

Arguments parseYamlArguments(YamlMap yaml) {
  final YamlList ignoreRaw = yaml['ignore'];
  return Arguments()
    ..intlFilename = yaml['intl']
    ..pubspecFilename = 'pubspec.yaml'
    ..outputFilename = 'assets.dart'
    ..ignoreAssets = ignoreRaw?.map((x) => x as String)?.toList() ?? [];
}

class AssetsBuilder extends Builder {
  /// This is needed to let build system know that we depend on given file
  Future<void> check(BuildStep buildStep, String filename) async {
    if (filename == null) {
      return;
    }

    await buildStep.canRead(AssetId(buildStep.inputId.package, filename));
  }

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    log.info('processing: ${buildStep.inputId}');

    final input = buildStep.inputId;

    final path = p.join(p.dirname(input.path), 'assets.dart');
    final output = AssetId(input.package, path);

    final configId = AssetId(input.package, 'lib/assets.yaml');

    final configRaw = loadYaml(await buildStep.readAsString(configId));
    final config = parseYamlArguments(configRaw ?? YamlMap());

    await check(buildStep, config.intlFilename);
    await check(buildStep, config.pubspecFilename);

    final generated = generate(config);

    await buildStep.writeAsString(output, generated);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        "assets.yaml": ["assets.dart"],
      };
}

Builder builder(BuilderOptions builderOptions) {
  log.info('creating AssetsBuilder');
  return AssetsBuilder();
}
