class ExchangeRate {
  ExchangeRate({
    required this.from,
    required this.to,
    required this.rate,
    required this.lastUpdated,
  });

  final String from;
  final String to;
  final double rate;
  final DateTime lastUpdated;
}
