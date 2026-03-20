extension StringExtensions on String? {
  String get orEmpty => this ?? '';
}

extension KeyExtensions on String {
  String formatKey() {
    if (isEmpty || length < 5) return '';
    return '••••••••${substring(length - 5, length)}';
  }
}
