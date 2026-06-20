/// Convenience extensions on [String] for common text transformations.
extension StringExtensions on String {
  /// Capitalizes the first letter of the string.
  ///
  /// Example: `'hello world'.capitalize` => `'Hello world'`
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Truncates the string to [maxLength] characters, appending an ellipsis
  /// if the string was longer.
  ///
  /// Example: `'Hello World'.truncate(5)` => `'Hello...'`
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  /// Converts the string to a URL-friendly slug.
  ///
  /// - Lowercases the string
  /// - Replaces spaces and special characters with hyphens
  /// - Removes consecutive hyphens
  /// - Trims leading/trailing hyphens
  ///
  /// Example: `'Ha Giang Province!'.toSlug` => `'ha-giang-province'`
  String get toSlug {
    return toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'[\s_]+'), '-')
        .replaceAll(RegExp('-+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }
}
