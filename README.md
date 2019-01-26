R.Flutter
====

Generate constants for resources which require using them as a String like fonts and assets.

Instead of writing:

```dart
AssetImage("assets/path/to/image.png")
```

```dart
TextStyle(
    fontFamily: "Roboto",
)
```

you can write:

```dart
AssetImage(Assets.image)
```

```dart
TextStyle(
    fontFamily: Fonts.roboto,
)
```

## Generate code

./flutterw packages pub run r_flutter:generate

Optional Parameters:
| Parameter     | Default value | Description                                                                             |
|---------------|---------------|-----------------------------------------------------------------------------------------|
| pubspec-file  | pubspec.yaml  | Specify the pubspec file of the project                                                 |
| ignore-assets |               | Specify asset folder which should be ignored for generating constants. Seperated by "," |
| output-file   | lib/r.g.dart  | Specify the output file.                                                                |
