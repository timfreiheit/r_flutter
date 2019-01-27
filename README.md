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

#### intl-file
Specify intl arb file to generate bindings for.

#### output-file (lib/r.g.dart)
Specify the output file.
