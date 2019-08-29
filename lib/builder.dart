import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:yaml/yaml.dart';

import 'src/arguments.dart';
import 'src/generator/generator.dart';
import 'src/model/resources.dart';
import 'src/parser/assets_parser.dart';
import 'src/parser/fonts_parser.dart';
import 'src/parser/strings_parser.dart';

Resources parseResources(Arguments arguments) {
  final pubspecFile = File(arguments.pubspecFilename).absolute;
  if (!pubspecFile.existsSync()) {
    print("pubspec file does not exists: " + pubspecFile.path);
    exit(1);
  }

  final yaml = loadYaml(pubspecFile.readAsStringSync());
  return Resources(
      fonts: parseFonts(yaml),
      assets: parseAssets(yaml, arguments.ignoreAssets),
      stringReferences: parseStrings(arguments.intlFilename));
}

Arguments parseYamlArguments(YamlMap yaml) {
  final arguments = Arguments()
    ..pubspecFilename = 'pubspec.yaml'
    ..outputFilename = 'assets.dart';

  yaml = yaml["r_flutter"];
  if (yaml == null) {
    return arguments;
  }

  final YamlList ignoreRaw = yaml['ignore'];
  arguments.ignoreAssets = ignoreRaw?.map((x) => x as String)?.toList() ?? [];
  arguments.intlFilename = yaml['intl'];

  return arguments;
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

    final output = AssetId(input.package, 'lib/assets.dart');

    final configId = AssetId(input.package, 'pubspec.yaml');

    final configRaw = loadYaml(await buildStep.readAsString(configId));
    final config = parseYamlArguments(configRaw ?? YamlMap());

    await check(buildStep, config.intlFilename);
    await check(buildStep, config.pubspecFilename);
    final res = parseResources(config);

    for (var decl in res.assets.declared) {
      if (decl.endsWith('/')) {
        final glob = Glob(decl + '*');
        final files = await buildStep.findAssets(glob).toList();
        log.finest('$glob $files');
      }
    }

    final generated = generateFile(res);
    await buildStep.writeAsString(output, generated);
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
