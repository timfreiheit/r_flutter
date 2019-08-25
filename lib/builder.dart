import 'dart:async';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'src/generator/generator.dart';
import 'src/model/resources.dart';
import 'src/parser/assets_parser.dart';
import 'src/parser/fonts_parser.dart';

class AssetsAndFontsBuilder extends Builder {
  @override
  FutureOr<void> build(BuildStep buildStep) async {
    log.info('AssetsAndFontsBuilder: ${buildStep.inputId}');
    var id = buildStep.inputId;
    final path = p.join(p.dirname(id.path), 'assets.dart');
    id = AssetId(id.package, path);

    final pubspec = await buildStep.findAssets(Glob('pubspec.yaml')).first;

    final yaml = loadYaml(await buildStep.readAsString(pubspec));
    final res = Resources(
      fonts: parseFonts(yaml),
      assets: parseAssets(yaml, []),
      stringReferences: [],
    );

    final generated = generateFile(res);

    await buildStep.writeAsString(id, generated);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        "assets.yaml": ["assets.dart"],
      };
}

Builder builder(BuilderOptions builderOptions) {
  log.info('creating AssetsAndFontsBuilder');
  return AssetsAndFontsBuilder();
}
