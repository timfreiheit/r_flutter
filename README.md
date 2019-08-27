r_flutter
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


## Setup

1. Add assets.yaml configuration file to in your app's lib directory:
```yaml
intl: lib/i18n/en.arb
ignore:
  - assets/sub/ignore1 #use ignore option to skip 
  - assets/sub/ignore2
  - lib/i18n
```
Options:
- intl: Points to a localization file that would be used to generate localization keys. arb files are essentialy json files with some special, optional keys. Specifing this is optional.
- ignore: specifies a list of files/directories that should be skipped during code generation. 

2. Add dependencies in your pubspec.yaml:
```yaml
dependencies:
  flutter:
    sdk: flutter
  runtime_arb:
    git: https://github.com/szotp/r_flutter.git
    path: runtime_arb

builders:
  r_flutter:
    git: https://github.com/szotp/r_flutter.git
```

3. Import `runtime_arb` package and add RuntimeArbDelegate to your localization delegates:
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
4. Execute `flutter generate` command in your project's directory. You could also run tests or just build the app. Compiler must run at least once to generate the file.

5. Import `assets.yaml` and start using it:
```dart
import 'assets.yaml'
Text(i18n.hello_there)
```

Note: if something doesn't work, check the example project.

