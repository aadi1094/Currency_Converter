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
      textInputAction: TextInputAction.next,
      initialValue: initialValue,
      onChanged: onChanged,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w700),
      decoration: const InputDecoration(
        labelText: 'Amount',
        hintText: 'Enter amount to convert',
        prefixIcon: Icon(Icons.payments_outlined),
        suffixIcon: Icon(Icons.tune_rounded),
      ),
    );
  }
}
