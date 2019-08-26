library runtime_arb;

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';

// ignore_for_file: implementation_imports

class RuntimeArb extends MessageLookupByLibrary {
  final String localeName;
  final Map<String, String> messages;

  RuntimeArb(this.localeName, this.messages);

  static Future<RuntimeArb> load(String localeName, String path) async {
    Intl.defaultLocale = localeName;

    final arb = await rootBundle.loadString(path);
    final Map<String, Object> parsed = json.decode(arb);

    parsed.removeWhere((key, value) {
      return !(value is String);
    });

    final result = RuntimeArb(localeName, parsed.cast());

    initializeInternalMessageLookup(() => CompositeMessageLookup());

    messageLookup.addLocale(localeName, (locale) {
      assert(locale == localeName);
      return result;
    });

    return result;
  }

  static final _regex = RegExp(r'{\w*}');

  String evaluateMessage(translation, List args) {
    String string = translation;

    if (args.isNotEmpty) {
      int i = 0;
      return string.replaceAllMapped(_regex, (_) {
        return args[i++];
      });
    } else {
      return string;
    }
  }
}

/// Loads localization strings from .arb file in assets.
/// 1. Make sure you have assets/i18n/en.arb and other languages.
/// 2. Add assets/i18n/ to your flutter assets.
/// 3. Correctly define supported locales.
class RuntimeArbDelegate extends LocalizationsDelegate<RuntimeArb> {
  final Set<String> locales;

  /// Patern to use when loading localization file. Must include {localeName} substring.
  /// Example: 'lib/i18n/{localeName}.arb'
  /// It is recommended that localization files are inside lib directory
  /// Otherwise code generation may not update properly
  final String pattern;

  const RuntimeArbDelegate(
    this.locales, [
    this.pattern = 'lib/i18n/{localeName}.arb',
  ]);

  @override
  bool isSupported(Locale locale) {
    return locales.contains(locale.languageCode);
  }

  @override
  Future<RuntimeArb> load(Locale locale) {
    final path = pattern.replaceFirst('{localeName}', locale.languageCode);
    return RuntimeArb.load(locale.languageCode, path);
  }

  @override
  bool shouldReload(LocalizationsDelegate<RuntimeArb> old) {
    return false;
  }
}
