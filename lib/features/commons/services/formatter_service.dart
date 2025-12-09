import 'package:intl/intl.dart';

class FormatterService {
  FormatterService._();

  static String formatAsCurrency(double valor) {
    return NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    ).format(valor);
  }
}
