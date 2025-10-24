import 'package:flutter/material.dart';

void main() {
  // Entry point for the currency converter application
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: CurrencyConverterPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> with TickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _result = 0.0;
  bool _isConverting = false;
  
  late AnimationController _resultAnimationController;
  late Animation<double> _resultAnimation;
  late AnimationController _swapAnimationController;
  late Animation<double> _swapAnimation;
  
  // Sample exchange rates (in a real app, you'd fetch from an API)
  final Map<String, double> _exchangeRates = {
    'USD': 1.0,
    'EUR': 0.85,
    'GBP': 0.73,
    'JPY': 110.0,
    'CAD': 1.25,
    'AUD': 1.35,
    'INR': 74.5,
    'CHF': 0.92,
    'CNY': 6.45,
    'SGD': 1.35,
  };

  final Map<String, IconData> _currencyIcons = {
    'USD': Icons.attach_money,
    'EUR': Icons.euro,
    'GBP': Icons.currency_pound,
    'JPY': Icons.currency_yen,
    'CAD': Icons.attach_money,
    'AUD': Icons.attach_money,
    'INR': Icons.currency_rupee,
    'CHF': Icons.attach_money,
    'CNY': Icons.currency_yen,
    'SGD': Icons.attach_money,
  };

  List<String> get _currencies => _exchangeRates.keys.toList();

  @override
  void initState() {
    super.initState();
    _resultAnimationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _resultAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _resultAnimationController, curve: Curves.elasticOut),
    );
    
    _swapAnimationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    _swapAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _swapAnimationController, curve: Curves.easeInOut),
    );
  }

  void _convertCurrency() async {
    final double amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount > 0) {
      setState(() {
        _isConverting = true;
      });
      
      // Simulate API call delay
      await Future.delayed(Duration(milliseconds: 300));
      
      final double usdAmount = amount / _exchangeRates[_fromCurrency]!;
      final double convertedAmount = usdAmount * _exchangeRates[_toCurrency]!;
      
      setState(() {
        _result = convertedAmount;
        _isConverting = false;
      });
      
      _resultAnimationController.forward();
    }
  }

  void _swapCurrencies() {
    _swapAnimationController.forward().then((_) {
      setState(() {
        final temp = _fromCurrency;
        _fromCurrency = _toCurrency;
        _toCurrency = temp;
      });
      _swapAnimationController.reverse();
      _convertCurrency();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.currency_exchange,
                        size: 50,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Currency Converter',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'Convert currencies instantly',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 20),
                
                // Amount Input Section
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  child: Card(
                    elevation: 15,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey[50]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.input, color: Colors.indigo[700], size: 24),
                                SizedBox(width: 10),
                                Text(
                                  'Enter Amount',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo[800],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.indigo.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _amountController,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  prefixIcon: Icon(Icons.attach_money, color: Colors.indigo[700], size: 28),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Colors.indigo[700]!, width: 2),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                ),
                                onChanged: (value) {
                                  _resultAnimationController.reset();
                                  _convertCurrency();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 25),
                
                // Currency Selection Section
                Card(
                  elevation: 15,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey[50]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.swap_horiz, color: Colors.indigo[700], size: 24),
                              SizedBox(width: 10),
                              Text(
                                'Select Currencies',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo[800],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildCurrencyDropdown('From', _fromCurrency, (value) {
                                  setState(() {
                                    _fromCurrency = value!;
                                  });
                                  _convertCurrency();
                                }),
                              ),
                              SizedBox(width: 15),
                              AnimatedBuilder(
                                animation: _swapAnimation,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _swapAnimation.value * 3.14159,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [Colors.indigo[400]!, Colors.indigo[700]!],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.indigo.withOpacity(0.3),
                                            blurRadius: 10,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        onPressed: _swapCurrencies,
                                        icon: Icon(
                                          Icons.swap_horiz,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: _buildCurrencyDropdown('To', _toCurrency, (value) {
                                  setState(() {
                                    _toCurrency = value!;
                                  });
                                  _convertCurrency();
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 25),
                
                // Convert Button
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [Colors.indigo[600]!, Colors.indigo[800]!],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.4),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isConverting ? null : _convertCurrency,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: _isConverting
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 15),
                              Text(
                                'Converting...',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.currency_exchange, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'Convert Currency',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                
                SizedBox(height: 30),
                
                // Result Section
                AnimatedBuilder(
                  animation: _resultAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _resultAnimation.value,
                      child: Card(
                        elevation: 15,
                        shadowColor: Colors.green.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [Colors.green[50]!, Colors.green[100]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.trending_up, color: Colors.green[700], size: 28),
                                    SizedBox(width: 10),
                                    Text(
                                      'Converted Amount',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[800],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(_currencyIcons[_toCurrency], color: Colors.green[700], size: 32),
                                      SizedBox(width: 10),
                                      Text(
                                        '${_result.toStringAsFixed(2)} $_toCurrency',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_result > 0) ...[
                                  SizedBox(height: 15),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.green[50],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.green[200]!),
                                    ),
                                    child: Text(
                                      '1 $_fromCurrency = ${(_exchangeRates[_toCurrency]! / _exchangeRates[_fromCurrency]!).toStringAsFixed(4)} $_toCurrency',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.green[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown(String label, String value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.indigo[700],
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.indigo[700]!, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            items: _currencies.map((currency) {
              return DropdownMenuItem(
                value: currency,
                child: Row(
                  children: [
                    Icon(_currencyIcons[currency], color: Colors.indigo[600], size: 20),
                    SizedBox(width: 8),
                    Text(
                      currency,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _resultAnimationController.dispose();
    _swapAnimationController.dispose();
    super.dispose();
  }
}