import 'package:flutter/material.dart';

import '../controllers/conversion_controller.dart';
import '../models/currency.dart';
import '../services/rate_service.dart';
import '../widgets/amount_input.dart';
import '../widgets/currency_selector.dart';
import '../widgets/conversion_result_card.dart';

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  late final ConversionController controller;

  static final currencies = <Currency>[
    const Currency(code: 'USD', name: 'US Dollar', symbol: 'USD'),
    const Currency(code: 'EUR', name: 'Euro', symbol: 'EUR'),
    const Currency(code: 'INR', name: 'Indian Rupee', symbol: 'INR'),
    const Currency(code: 'GBP', name: 'British Pound', symbol: 'GBP'),
    const Currency(code: 'JPY', name: 'Japanese Yen', symbol: 'JPY'),
    const Currency(code: 'AUD', name: 'Australian Dollar', symbol: 'AUD'),
    const Currency(code: 'CAD', name: 'Canadian Dollar', symbol: 'CAD'),
    const Currency(code: 'CHF', name: 'Swiss Franc', symbol: 'Fr'),
    const Currency(code: 'CNY', name: 'Chinese Yuan', symbol: 'CNY'),
  ];

  @override
  void initState() {
    super.initState();
    controller = ConversionController(
      rateService: LocalRateService(),
      currencies: currencies,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        actions: [
          IconButton(
            tooltip: 'Swap currencies',
            icon: const Icon(Icons.swap_vert),
            onPressed: controller.swap,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Convert between currencies with offline sample rates.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        AmountInput(
                          initialValue: controller.amountText,
                          onChanged: controller.setAmount,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: CurrencySelector(
                                label: 'From',
                                currencies: currencies,
                                value: controller.from,
                                onChanged: controller.setFrom,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CurrencySelector(
                                label: 'To',
                                currencies: currencies,
                                value: controller.to,
                                onChanged: controller.setTo,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: controller.isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.calculate_outlined),
                            label: Text(controller.isLoading ? 'Converting...' : 'Convert'),
                            onPressed: controller.isLoading ? null : controller.convert,
                          ),
                        ),
                        if (controller.error != null) ...[
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  controller.error!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (controller.convertedValue != null)
                  ConversionResultCard(
                    amount: controller.convertedValue!,
                    toCode: controller.to!.code,
                    rate: controller.latestRate,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
