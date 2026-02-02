import 'package:flutter/foundation.dart';

import '../models/currency.dart';
import '../models/exchange_rate.dart';
import '../services/rate_service.dart';

class ConversionHistoryEntry {
  ConversionHistoryEntry({
    required this.amount,
    required this.fromCode,
    required this.toCode,
    required this.rate,
    required this.result,
    required this.timestamp,
  });

  final double amount;
  final String fromCode;
  final String toCode;
  final double rate;
  final double result;
  final DateTime timestamp;
}

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
  final List<ConversionHistoryEntry> history = [];

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
      _addHistory(
        ConversionHistoryEntry(
          amount: parsedAmount,
          fromCode: rate.from,
          toCode: rate.to,
          rate: rate.rate,
          result: convertedValue!,
          timestamp: rate.lastUpdated,
        ),
      );
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

  void _addHistory(ConversionHistoryEntry entry) {
    history.insert(0, entry);
    if (history.length > 5) {
      history.removeLast();
    }
  }
}
