import 'package:intl/intl.dart';

String formatToBRL(double value) {
  final currencyFormat = NumberFormat.currency(
    locale: 'pt_BR', // Define o locale como Brasil
    symbol: 'R\$',
  );
  return currencyFormat.format(value);
}
