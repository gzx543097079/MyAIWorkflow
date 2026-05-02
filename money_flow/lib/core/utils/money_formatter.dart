class MoneyFormatter {
  const MoneyFormatter._();

  static String yuanFromCents(int cents) {
    final yuan = cents / 100;
    return '¥${yuan.toStringAsFixed(2)}';
  }
}
