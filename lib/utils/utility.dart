String removeWhitespaces(String string) {
  return string.replaceAll(new RegExp(r"\s+"), "");
}
String removeNewLine(String string) {
  return string.replaceAll(new RegExp(r"\n+"), "");
}

String removeTab(String string) {
  return string.replaceAll(new RegExp(r"\t+"), "");
}
List<String> splitWhitespaces(String string) {
  return string.split(new RegExp(r"\s+"));
}