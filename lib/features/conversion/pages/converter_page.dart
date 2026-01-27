import 'dart:ui';

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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Swap currencies',
            icon: const Icon(Icons.autorenew_rounded),
            onPressed: controller.swap,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF7FAFF), Color(0xFFE8F0FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroCard(textTheme, colorScheme),
                    const SizedBox(height: 18),
                    _buildConversionCard(context, colorScheme),
                    const SizedBox(height: 16),
                    if (controller.convertedValue != null)
                      ConversionResultCard(
                        amount: controller.convertedValue!,
                        toCode: controller.to!.code,
                        rate: controller.latestRate,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroCard(TextTheme textTheme, ColorScheme colorScheme) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.secondary.withOpacity(0.92),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Convert between currencies with offline sample rates.',
              style: textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Elegant, offline-ready currency studio.',
              style: textTheme.headlineMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                _HeroChip(icon: Icons.offline_bolt_rounded, label: 'Offline sample rates'),
                _HeroChip(icon: Icons.timeline_rounded, label: 'Friendly UI'),
                _HeroChip(icon: Icons.shield_moon_rounded, label: 'No network required'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversionCard(BuildContext context, ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.86),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.65)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.wallet_rounded, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Set up your conversion',
                    style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
                  IconButton.filledTonal(
                    tooltip: 'Swap currencies',
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.primary.withOpacity(0.08),
                      foregroundColor: colorScheme.primary,
                    ),
                    icon: const Icon(Icons.swap_horiz_rounded),
                    onPressed: controller.swap,
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
              _buildConvertButton(colorScheme),
              if (controller.error != null) ...[
                const SizedBox(height: 12),
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
    );
  }

  Widget _buildConvertButton(ColorScheme colorScheme) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.28),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
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
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size.fromHeight(54),
        ),
        onPressed: controller.isLoading ? null : controller.convert,
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.white.withOpacity(0.16),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
