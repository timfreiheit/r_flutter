import 'package:args/args.dart';

class Arguments {
  String pubspecFilename;
  String outputFilename;

  void parse(List<String> args) {
    var parser = new ArgParser();

    parser.addOption("pubspec-file",
        defaultsTo: 'pubspec.yaml',
        callback: (value) => pubspecFilename = value,
        help: 'Specify the output file.');
    parser.addOption("output-file",
        defaultsTo: 'lib/r.g.dart',
        callback: (value) => outputFilename = value,
        help: 'Specify the output file.');
    parser.parse(args);
  }
}
