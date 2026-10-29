import 'package:intl/intl.dart';

class Formatters {
  static String currency(num amount, {String symbol = '\$'}) {
    final fmt = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return fmt.format(amount);
  }

  static String dateShort(DateTime dt) => DateFormat.yMMMd().format(dt);
}
