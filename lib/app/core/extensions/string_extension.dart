/// String extensions
extension StringExtension on String {
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize each word
  String get capitalizeEach {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Check if string is email
  bool get isEmail {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(this);
  }

  /// Check if string is phone number
  bool get isPhoneNumber {
    final regex = RegExp(r'^[+]?[0-9]{8,15}$');
    return regex.hasMatch(replaceAll(' ', '').replaceAll('-', ''));
  }

  /// Check if string is URL
  bool get isUrl {
    final regex = RegExp(r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$');
    return regex.hasMatch(this);
  }

  /// Check if string is numeric
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  /// Remove all whitespace
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Convert to int
  int? get toIntOrNull {
    return int.tryParse(this);
  }

  /// Convert to double
  double? get toDoubleOrNull {
    return double.tryParse(this);
  }

  /// Check if string is null or empty
  bool get isNullOrEmpty {
    return isEmpty;
  }

  /// Check if string is not null or empty
  bool get isNotNullOrEmpty {
    return isNotEmpty;
  }

  /// Reverse string
  String get reverse {
    return split('').reversed.join();
  }

  /// Count occurrences of a substring
  int countOccurrences(String substring) {
    int count = 0;
    int index = 0;
    while ((index = indexOf(substring, index)) != -1) {
      count++;
      index += substring.length;
    }
    return count;
  }
}

/// Nullable string extensions
extension NullableStringExtension on String? {
  /// Check if string is null or empty
  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }

  /// Check if string is not null or empty
  bool get isNotNullOrEmpty {
    return this != null && this!.isNotEmpty;
  }

  /// Return string or default value
  String orDefault([String defaultValue = '']) {
    return isNullOrEmpty ? defaultValue : this!;
  }
}
