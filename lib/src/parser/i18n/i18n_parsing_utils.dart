List<String> findPlaceholders(String value) {
  return RegExp(r"{[a-zA-Z0-9]+}")
      .allMatches(value)
      .map((item) => item.group(0).replaceAll("{", "").replaceAll("}", ""))
      .toList();
}
