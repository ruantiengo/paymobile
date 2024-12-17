import 'package:intl/intl.dart';

String formatToBRL(double value) {
  final currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );
  return currencyFormat.format(value);
}
