import 'package:flutter/foundation.dart';

import '../models/currency.dart';
import '../models/exchange_rate.dart';
import '../services/rate_service.dart';

class ConversionController extends ChangeNotifier {
  ConversionController({required this.rateService, required this.currencies}) {
    from = currencies.first;
    to = currencies.length > 1 ? currencies[1] : currencies.first;
  }

  final RateService rateService;
  final List<Currency> currencies;

  Currency? from;
  Currency? to;
  String amountText = '';
  double? convertedValue;
  ExchangeRate? latestRate;
  bool isLoading = false;
  String? error;

  void setFrom(Currency? currency) {
    from = currency;
    _clearResult();
    notifyListeners();
  }

  void setTo(Currency? currency) {
    to = currency;
    _clearResult();
    notifyListeners();
  }

  void swap() {
    final currentFrom = from;
    from = to;
    to = currentFrom;
    _clearResult();
    notifyListeners();
  }

  void setAmount(String value) {
    amountText = value;
    _clearResult();
    notifyListeners();
  }

  Future<void> convert() async {
    if (from == null || to == null) return;
    final parsedAmount = double.tryParse(amountText.replaceAll(',', ''));
    if (parsedAmount == null || parsedAmount <= 0) {
      error = 'Enter a valid amount greater than 0';
      notifyListeners();
      return;
    }

    error = null;
    isLoading = true;
    notifyListeners();

    try {
      final rate = await rateService.fetchRate(from: from!.code, to: to!.code);
      latestRate = rate;
      convertedValue = parsedAmount * rate.rate;
    } catch (e) {
      error = 'Unable to fetch rate';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _clearResult() {
    convertedValue = null;
    latestRate = null;
    error = null;
  }
}
