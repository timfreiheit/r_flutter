import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/resources.dart';

DartClass generateStringBindingClass(List<StringReference> stringReferences) {
  if (stringReferences.isEmpty) {
    return null;
  }

  String classString = "class StringsBinding {\n";
  for (var ref in stringReferences) {
    if (ref.placeholders.isEmpty) {
      classString +=
          '  String get ${ref.name} => Intl.message("", name: "${ref.name}");\n';
    } else {
      classString += '  String ${ref.name}(';
      for (var placeholder in ref.placeholders) {
        if (!classString.endsWith("(")) {
          classString += ", ";
        }
        classString += "String ${placeholder}";
      }
      classString += ") {\n";
      classString +=
          '    return Intl.message("", name: "${ref.name}", args: ['; // number])
      for (var placeholder in ref.placeholders) {
        if (!classString.endsWith("[")) {
          classString += ", ";
        }
        classString += placeholder;
      }
      classString += "]);\n";
      classString += "  }\n";
    }
  }
  classString += "}\n";

  return DartClass(
    imports: ["package:intl/intl.dart"],
    code: classString,
  );
}
