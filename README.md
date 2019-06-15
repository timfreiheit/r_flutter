R.Flutter
====

Generate constants for resources which require using them as a String like fonts and assets.

##### Images

Instead of writing:
```dart
Image(image: AssetImage("assets/path/to/image.png"))
```
you can write:
```dart
Image(image: Images.image)
```

##### Fonts
Instead of writing:
```dart
TextStyle(
    fontFamily: "Roboto",
)
```
you can write:
```dart
TextStyle(
    fontFamily: Fonts.roboto,
)
```

##### Fonts
Instead of writing:
```dart
await rootBundle.loadString("assets/path/to/data.json")
```
you can write:
```dart
await rootBundle.loadString(Assets.data)
```


## Generate code

```
flutter packages pub run r_flutter:generate
```

#### Optional Parameters:

##### pubspec-file (pubspec.yaml)
Specify the pubspec file of the project

#### ignore-assets
Specify asset folder which should be ignored for generating constants. Seperated by "," 

example:
```
flutter packages pub run r_flutter:generate \
  --ignore-assets=assets/thumbs/,assets/large_collection_of_files
```

#### intl-file
Specify intl arb file to generate bindings for.

example:
```
flutter packages pub run r_flutter:generate --intl-file=lib/i18n/strings_en.arb
```

this generates a ``` StringsBinding ``` which looks like

```dart
class StringsBinding {
  String get appName => Intl.message("", name: "appName");
}
```

usage with the intl
```dart
class Strings extends StringsBinding {

  final Locale _locale;

  Strings(this._locale);

  static Future<Strings> load(Locale locale) async {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    await initializeMessages(localeName);
    Intl.defaultLocale = localeName;
    return new Strings(locale);
  }

  static Strings of(BuildContext context) {
    return Localizations.of<Strings>(context, Strings);
  }
}
```

#### output-file (lib/r.g.dart)
Specify the output file.
