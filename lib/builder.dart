import 'dart:async';

import 'package:build/build.dart';

class MyBuilder extends Builder {
  @override
  FutureOr<void> build(BuildStep buildStep) {
    throw 'lol2';
    return Future.value();
  }

  @override
  Map<String, List<String>> get buildExtensions {
    return {
      ".json": [".dart"]
    };
  }
}

Builder builder(BuilderOptions builderOptions) => MyBuilder();
