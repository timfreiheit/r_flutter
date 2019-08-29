r_flutter
====

Generate constants for resources which require using them as a String like fonts and assets. Generated file will look like this:
[assets.dart](/example/.dart_tool/build/generated/example/lib/assets.dart)

## Setup

1. Ensure that your assets and localization files are inside lib directory. This is required for builder plugin to detect changes.

2. Add dependencies in your pubspec.yaml:
```yaml
dependencies:
  flutter:
    sdk: flutter
  runtime_arb:
    git: 
      url: https://github.com/timfreiheit/r_flutter.git
      path: runtime_arb

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

4. Import `runtime_arb` package and add RuntimeArbDelegate to your localization delegates:
```dart
MaterialApp(
  title: 'r_flutter',
  localizationsDelegates: [
    // runtimeArbDelegate will expect lib/i18n/en.arb and lib/i18n/en.arb to exist in your app
    // make sure they have been added to your assets
    RuntimeArbDelegate({'en', 'pl'})
  ],
  home: HomePage(),
)
```
5. Execute `flutter generate` command in your project's directory. You could also run tests or just build the app. Compiler must run at least once to generate the file.

6. Import `assets.yaml` and start using it:
```dart
import 'assets.yaml'
Text(i18n.hello_there)
```

Note: if something doesn't work, check the example project.

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

