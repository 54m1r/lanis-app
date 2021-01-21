String removeWhitespaces(String string) {
  return string.replaceAll(new RegExp(r"\s+"), "");
}