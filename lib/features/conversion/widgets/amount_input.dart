import 'package:flutter/material.dart';

class AmountInput extends StatefulWidget {
  const AmountInput({
    super.key,
    required this.onChanged,
    required this.value,
  });

  final ValueChanged<String> onChanged;
  final String value;

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant AmountInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
      _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TextFormField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      onChanged: widget.onChanged,
      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        labelText: 'Amount',
        hintText: 'Enter amount to convert',
        prefixIcon: const Icon(Icons.payments_outlined),
        suffixIcon: widget.value.isNotEmpty
            ? IconButton(
                tooltip: 'Clear amount',
                icon: const Icon(Icons.clear_rounded),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                },
              )
            : const Icon(Icons.tune_rounded),
      ),
    );
  }
}
