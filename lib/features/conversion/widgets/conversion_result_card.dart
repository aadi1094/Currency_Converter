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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.08),
            colorScheme.secondary.withOpacity(0.14),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  foregroundColor: colorScheme.primary,
                  child: const Icon(Icons.trending_up_rounded, size: 18),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Converted Amount',
                      style: textTheme.bodySmall?.copyWith(color: Colors.black54),
                    ),
                    Text(
                      'Ready to use',
                      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
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
            const SizedBox(height: 10),
            if (rate != null)
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 18, color: Colors.black54),
                  const SizedBox(width: 6),
                  Text(
                    '1 ${rate!.from} = ${rate!.rate.toStringAsFixed(4)} ${rate!.to}',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
