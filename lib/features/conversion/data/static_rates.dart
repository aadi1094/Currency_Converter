const Map<String, double> usdToCurrency = {
  'USD': 1.0,
  'EUR': 0.92,
  'INR': 83.1,
  'GBP': 0.79,
  'JPY': 148.3,
  'AUD': 1.51,
  'CAD': 1.34,
  'CHF': 0.86,
  'CNY': 7.15,
};

double? crossRate(String from, String to) {
  if (from == to) return 1;
  final fromRate = usdToCurrency[from];
  final toRate = usdToCurrency[to];
  if (fromRate == null || toRate == null) return null;
  return (1 / fromRate) * toRate;
}
