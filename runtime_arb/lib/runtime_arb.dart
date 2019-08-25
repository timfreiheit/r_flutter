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

  static Future<RuntimeArb> load(Locale locale) async {
    final String localeName = locale.languageCode;

    Intl.defaultLocale = localeName;

    final arb = await rootBundle.loadString('assets/i18n/$localeName.arb');
    final Map<String, Object> parsed = json.decode(arb);

    parsed.removeWhere((key, value) {
      return !(value is String);
    });

    final result = RuntimeArb(locale.languageCode, parsed.cast());

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

  const RuntimeArbDelegate(this.locales);

  @override
  bool isSupported(Locale locale) {
    return locales.contains(locale.languageCode);
  }

  @override
  Future<RuntimeArb> load(Locale locale) {
    return RuntimeArb.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<RuntimeArb> old) {
    return false;
  }
}
