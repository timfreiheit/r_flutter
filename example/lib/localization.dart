import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';

import 'assets.dart';

// ignore_for_file: implementation_imports

class Strings extends StringsBinding with MessageLookupByLibrary {
  final String localeName;
  final Map<String, String> messages;

  Strings(this.localeName, this.messages);

  static Future<Strings> load(Locale locale) async {
    final String localeName = locale.languageCode;

    Intl.defaultLocale = localeName;

    final arb = await rootBundle.loadString('assets/i18n/$localeName.arb');
    final Map<String, Object> parsed = json.decode(arb);

    parsed.removeWhere((key, value) {
      return !(value is String);
    });

    final result = Strings(locale.languageCode, parsed.cast());

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

  static Strings of(BuildContext context) {
    return Localizations.of<Strings>(context, Strings);
  }
}

class StringsDelegate extends LocalizationsDelegate<Strings> {
  final Set<String> locales;

  const StringsDelegate(this.locales);

  @override
  bool isSupported(Locale locale) {
    return locales.contains(locale.languageCode);
  }

  @override
  Future<Strings> load(Locale locale) {
    return Strings.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<Strings> old) {
    return false;
  }
}
