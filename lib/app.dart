import 'package:flutter/material.dart';
import 'features/conversion/pages/converter_page.dart';
import 'theme/app_theme.dart';

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: AppTheme.light,
      home: const ConverterPage(),
    );
  }
}
