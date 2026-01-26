import 'package:flutter/material.dart';

import '../models/exchange_rate.dart';

class ConversionResultCard extends StatelessWidget {
  const ConversionResultCard({
    super.key,
    required this.amount,
    required this.toCode,
    required this.rate,
  });

  final double amount;
  final String toCode;
  final ExchangeRate? rate;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Converted Amount',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount.toStringAsFixed(2),
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(toCode, style: textTheme.bodyMedium),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (rate != null)
              Text(
                '1 ${rate!.from} = ${rate!.rate.toStringAsFixed(4)} ${rate!.to}',
                style: textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}
