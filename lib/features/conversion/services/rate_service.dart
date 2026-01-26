import 'dart:async';

import '../data/static_rates.dart';
import '../models/exchange_rate.dart';

abstract class RateService {
  Future<ExchangeRate> fetchRate({required String from, required String to});
}

class LocalRateService implements RateService {
  @override
  Future<ExchangeRate> fetchRate({required String from, required String to}) async {
    final rate = crossRate(from, to);
    if (rate == null) {
      throw StateError('Unsupported currency pair $from/$to');
    }
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return ExchangeRate(
      from: from,
      to: to,
      rate: rate,
      lastUpdated: DateTime.now(),
    );
  }
}
