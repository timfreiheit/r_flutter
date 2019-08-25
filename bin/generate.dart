#!/usr/bin/env dart
import 'dart:io';

import 'package:r_flutter/builder.dart';
import 'package:r_flutter/src/arguments.dart';

main(List<String> args) {
  var arguments = Arguments();
  arguments.parse(args);

  final contents = generate(arguments);

  final outoutFile = File(arguments.outputFilename);
  outoutFile.writeAsStringSync(contents);

  print("${outoutFile.path} generated successfully");
}
