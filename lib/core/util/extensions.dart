extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String capitalizeFirstOfEach() {
    // remove the - and replace with space
    String newString = replaceAll("-", " ");
    return newString.split(" ")
        .map((str) => str.capitalize())
        .toList()
        .join(" ");
  }
}