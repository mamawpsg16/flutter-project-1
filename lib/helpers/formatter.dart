import 'package:intl/intl.dart';

String formatDate(DateTime? date, {String format = 'MMM d, yyyy h:mm a'}) {
  if (date == null) return '-';
  return DateFormat(format).format(date);
}

String formatCurrency(double? amount, {String locale = 'en_PH', String symbol = '₱'}) {
  final formatter = NumberFormat.currency(
    locale: locale,
    symbol: symbol,
    decimalDigits: 2,
  );
  return formatter.format(amount ?? 0.0); // Fallback to 0.0 if null
}
