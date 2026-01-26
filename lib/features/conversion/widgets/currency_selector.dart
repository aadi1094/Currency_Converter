import 'package:flutter/material.dart';

import '../models/currency.dart';

class CurrencySelector extends StatelessWidget {
  const CurrencySelector({
    super.key,
    required this.label,
    required this.currencies,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final List<Currency> currencies;
  final Currency? value;
  final ValueChanged<Currency?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Currency>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.public),
      ),
      items: currencies
          .map(
            (c) => DropdownMenuItem<Currency>(
              value: c,
              child: Text('${c.code} · ${c.name}'),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
