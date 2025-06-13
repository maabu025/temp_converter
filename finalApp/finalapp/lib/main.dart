import 'package:flutter/material.dart';

void main() => runApp(TempConverterApp());

class TempConverterApp extends StatelessWidget {
  const TempConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: TempConverterScreen(),
    );
  }
}

class TempConverterScreen extends StatefulWidget {
  const TempConverterScreen({super.key});

  @override
  State<TempConverterScreen> createState() => _TempConverterScreenState();
}

class _TempConverterScreenState extends State<TempConverterScreen> {
  final TextEditingController _controller = TextEditingController();
  String _convertedValue = '';
  bool _isCelsiusToFahrenheit = true;
  final List<String> _conversionHistory = [];

  void _convertTemperature() {
    final input = double.tryParse(_controller.text);
    if (input == null) {
      setState(() {
        _convertedValue = 'Please enter a valid number';
      });
      return;
    }

    double result;
    String resultText;

    if (_isCelsiusToFahrenheit) {
      result = (input * 9 / 5) + 32;
      resultText = '${input.toStringAsFixed(2)} °C = ${result.toStringAsFixed(2)} °F';
    } else {
      result = (input - 32) * 5 / 9;
      resultText = '${input.toStringAsFixed(2)} °F = ${result.toStringAsFixed(2)} °C';
    }

    setState(() {
      _convertedValue = resultText;
      _conversionHistory.insert(0, resultText); // Add to top of history
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        backgroundColor: Colors.blue, // Blue header background
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isPortrait ? _buildVerticalLayout() : _buildHorizontalLayout(),
      ),
    );
  }

  Widget _buildVerticalLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildChildren(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChildren() {
    return [
      TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: _isCelsiusToFahrenheit ? 'Enter °C' : 'Enter °F',
        ),
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Convert to:'),
          Switch(
            value: _isCelsiusToFahrenheit,
            onChanged: (value) {
              setState(() {
                _isCelsiusToFahrenheit = value;
                _convertedValue = '';
              });
            },
          ),
          Text(_isCelsiusToFahrenheit ? 'Fahrenheit' : 'Celsius'),
        ],
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: _convertTemperature,
        child: const Text('Convert'),
      ),
      const SizedBox(height: 20),
      Text(
        _convertedValue,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 30),
      const Text(
        'Conversion History',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      _conversionHistory.isEmpty
          ? const Text('No conversions yet.')
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _conversionHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(_conversionHistory[index]),
                );
              },
            ),
    ];
  }
}
