import 'dart:io';

import 'package:r_flutter/builder.dart';
import 'package:r_flutter/src/arguments.dart';
import 'package:r_flutter/src/generator/generator.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import 'current_directory.dart';

Config loadPubspec(String name, String currentDirectory) {
  setCurrentDirectory(null);
  setCurrentDirectory(Directory.current.path + "/" + currentDirectory);
  final yaml = loadYaml(File(name).readAsStringSync());
  final args = Config.parsePubspecConfig(yaml);
  args.pubspecFilename = name;
  return args;
}

String processPubspec(String name, [String currentDirectory = 'test']) {
  final arguments = loadPubspec(name, currentDirectory);
  final res = parseResources(arguments);
  final contents = generateFile(res, arguments);
  return contents;
}

void main() {
  test('test example', () {
    final contents = processPubspec('pubspec.yaml', 'example');
    expect(contents, isNotNull);
  });

  test('test asset classes', () {
    final contents = processPubspec('pubspec_asset_classes.yaml');
    expect(contents, contains('SvgFile'));
    expect(contents, contains('TxtFile'));
  });

  test('test simple', () {
    final contents = processPubspec('pubspec_simple.yaml');
    expect(contents, contains('svg.svg'));
  });

  setCurrentDirectory(null);
}
