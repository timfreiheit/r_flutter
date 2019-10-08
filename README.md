r_flutter
====

Generate constants for resources which require using them as a String like fonts and assets. Generated file will look like this:
[assets.dart](https://github.com/timfreiheit/r_flutter/blob/master/example/.dart_tool/build/generated/example/lib/assets.dart)

## Setup

1. Ensure that your assets and localization files are inside lib directory. This is required for builder plugin to detect changes.

2. Add dependencies in your pubspec.yaml:
```yaml
dependencies:
  flutter:
    sdk: flutter

builders:
  r_flutter: <version>
```

3. Add r_flutter configuration in your pubspec.yaml:
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

4. Execute `flutter generate` command in your project's directory. You could also run tests or just build the app. Compiler must run at least once to generate the file.
`assets.dart` will be generated into `.dart_tool/build/generated/YOUR_PACKAGE_NAME/assets.dart`

5. Import `assets.dart` and start using it:
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

Other locales will be searched at ` lib/i18n/<locale>.arb `

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

#### `assets.dart` not found

Execute `flutter generate` command in your project's directory. You could also run tests or just build the app. Compiler must run at least once to generate the file.
`assets.dart` will be generated into `.dart_tool/build/generated/YOUR_PACKAGE_NAME/assets.dart`

#### news keys not resolvable in IDE

When `assets.dart` is regenerated, sometimes it is not correctly indexed by the IDE:
Building should run anyway, even though that the IDE shows an error.

If the error constits, check the `assets.dart` and maybe add a Whitespace somewhere. That will trigger the IDE to re-index.

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
