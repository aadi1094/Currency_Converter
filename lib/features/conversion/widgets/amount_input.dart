import 'package:flutter/material.dart';

class AmountInput extends StatelessWidget {
  const AmountInput({
    super.key,
    required this.onChanged,
    required this.initialValue,
  });

  final ValueChanged<String> onChanged;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      initialValue: initialValue,
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'Amount',
        hintText: 'Enter amount to convert',
        prefixIcon: Icon(Icons.payments_outlined),
      ),
    );
  }
}
