import 'package:args/args.dart';

class Arguments {
  String pubspecFilename;
  List<String> ignoreAssets = [];
  String outputFilename;

  void parse(List<String> args) {
    ArgParser()
      ..addOption(
        "pubspec-file",
        defaultsTo: 'pubspec.yaml',
        callback: (value) => pubspecFilename = value,
        help: 'Specify the pubspec file.',
      )
      ..addOption(
        "ignore-assets",
        defaultsTo: '',
        callback: (String value) {
          ignoreAssets =
              value.split(r";").where((item) => item.isNotEmpty).toList();
        },
        help:
            'Specify asset folder which should be ignored for generating constants. Seperated by ";"',
      )
      ..addOption(
        "output-file",
        defaultsTo: 'lib/r.g.dart',
        callback: (value) => outputFilename = value,
        help: 'Specify the output file.',
      )
      ..parse(args);
  }
}
