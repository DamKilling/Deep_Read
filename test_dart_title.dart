void main() {
  String title = "CHAPTER I. Jonathan Harker's Journal CHAPTER II. Jonathan Harker's Journal CHAPTER III.";
  var parts = title.split(RegExp(r'CHAPTER', caseSensitive: false));
  if (parts.length > 2) {
    print("Found multiple chapters! Returning fallback.");
    print(title.substring(0, title.indexOf('CHAPTER', 1)).trim());
  }
}
