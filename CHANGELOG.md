## 0.9.0
  * Add support for webp images
  * Add support for i18n features
  * Thanks to [@kostadin-damyanov-prime](https://github.com/kostadin-damyanov-prime)

## 0.8.0
  * remove deprecated `flutter generate`. Use `build_runner` instead

## 0.7.1 (BREAKING CHANGE)

  * r_flutter generates now nullsafe code, if you update to v0.7.0, your project should target dart >= 2.12
  * code generator itself is nullsafe as well
  * Thanks to [@vishna](https://github.com/vishna)

## 0.6.0

  * add support for script code in i18n files. Thanks to [@chen-yumin](https://github.com/chen-yumin)

## 0.5.1

  * fix locales with country code without support for the base language

## 0.5.0

* align command line and builder capabilities

## 0.4.1

* fix crash when none default locales have additional keys

## 0.4.0

* generate complete i18n code.
    * there is no need for the RuntimeArb anymore
    * see the README for integration steps

## 0.3.1

* fix NullPointerException when trying to access undefined asset classes

## 0.3.0

* add custom asset classes support. Thanks to [@szotp](https://github.com/szotp)
* add file uri comments to assets to get image preview in autocomplete
* ignore .DS_Store from code generation

## 0.2.1

* add support to dart builder to automatically integrate into the normal build process. Thanks to [@szotp](https://github.com/szotp)
