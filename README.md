r_flutter
====

Generate constants for resources which require using them as a String like fonts and assets. Generated file will look like this:
[assets.dart](https://github.com/timfreiheit/r_flutter/blob/master/example/lib/assets.dart)

## Setup

1. Add dependencies in your pubspec.yaml:
```yaml
dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  build_runner:
  r_flutter: <version>
```

2. Add r_flutter configuration in your pubspec.yaml:
```yaml
# important: this is root level option
r_flutter:
  intl: lib/i18n/en.arb
  ignore:
    - lib/assets/sub/ignore1 #use ignore option to skip 
    - lib/assets/sub/ignore2
    - lib/i18n
```
Options:
- intl: Points to a localization file that would be used to generate localization keys. arb files are essentialy json files with some special, optional keys. Specifing this is optional.
- ignore: specifies a list of files/directories that should be skipped during code generation. 

3. Execute `flutter packages pub run build_runner build` command in your project's directory. You could also run tests or just build the app. Compiler must run at least once to generate the file.
`assets.dart` will be generated into `lib/assets.dart`

4. Import `assets.dart` and start using it:
```dart
import 'assets.dart'
Image(image: Images.image)
```

Note: if something doesn't work, check the example project.

### I18n

1. Add default localization file to `pubspec.yaml`
```yaml
r_flutter:
  intl: lib/i18n/en.arb
```

Other locales will be searched under the same folder as the default localization file (e.g. `lib/i18n/`) for the following 4 formats:

- `<language_code>.arb` (e.g.: `en.arb`, `zh.arb`)
- `<language_code>_<country_code>.arb` (e.g.: `en_US.arb`, `en_GB.arb`)
- `<language_code>_<script_code>.arb` (e.g.: `zh_Hans.arb`, `zh_Hant.arb`)
- `<language_code>_<script_code>_<country_code>.arb` (e.g.: `zh_Hans_CN.arb`, `zh_Hant_TW.arb`, `zh_Hant_HK.arb`)

Where `<language_code>` consists of 2 lowercase letters ([ISO 639-1](https://en.wikipedia.org/wiki/ISO_639-1)); `<country_code>` consists of 2 uppercase letters ([ISO_3166-2](https://en.wikipedia.org/wiki/ISO_3166-2)); `<script_code>` consists of 4 letters with the first letter being capitalized ([ISO 15924](https://en.wikipedia.org/wiki/ISO_15924)).

2. Add it to your app.
```dart
MaterialApp(
  title: 'r_flutter',
  supportedLocales: I18n.supportedLocales,
  localizationsDelegates: [
    I18n.delegate
  ],
  home: HomePage(),
)
```

3. Use it
```dart
import 'assets.dart'
Text(I18n.of(context).hello)
```

### Custom asset classes

r_flutter supports third party packages like flutter_svg by providing option to convert generated constants directly into the desired class. To use it, you need to configure which file extension should by handled by which class, for example:

```yaml
r_flutter:
  asset_classes:
    ".svg": 
      import: asset_classes.dart
      class: SvgFile
```
And then, r_flutter will use SvgFile class for all svg assets:
```dart
static const SvgFile svg = SvgFile("lib/assets/svg.svg")
```

## Troubleshooting

#### iOS won't show the correct language

The iOS project need to be updated: [Documentation](https://flutter.dev/docs/development/accessibility-and-localization/internationalization#appendix-updating-the-ios-app-bundle)

## Examples

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
