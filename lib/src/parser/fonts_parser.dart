List<String> parseFonts(yaml) {
  final flutter = yaml["flutter"];
  if (flutter == null) {
    return [];
  }

  List fonts = flutter["fonts"];
  if (fonts == null) {
    return [];
  }

  return fonts.map((item) {
    return item["family"] as String;
  }).toList();
}
