import 'package:flutter/material.dart';

void main() {
  runApp(const TempConverterApp());
}

class TempConverterApp extends StatelessWidget {
  const TempConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      home: const TempConverterAppScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TempConverterAppScreen extends StatefulWidget {
  const TempConverterAppScreen({super.key});

  @override
  State<TempConverterAppScreen> createState() => _TempConverterScreenState();
}

class _TempConverterScreenState extends State<TempConverterAppScreen> {
  final TextEditingController _controller = TextEditingController();
  String _convertedValue = '';
  bool _isCelsiusToFahrenheit = true;
  final List<String> _conversionHistory = [];
  
//Validate user input
  void _convertTemperature() {
    final input = double.tryParse(_controller.text);
    if (input == null) {
      setState(() {
        _convertedValue = 'Please enter a valid number';
      });
      return;
    }

    double result;
    String record;
    if (_isCelsiusToFahrenheit) {
      result = (input * 9 / 5) + 32;
      _convertedValue = '${result.toStringAsFixed(2)} °F';
      record = '$input °C → ${result.toStringAsFixed(2)} °F';
    } else {
      result = (input - 32) * 5 / 9;
      _convertedValue = '${result.toStringAsFixed(2)} °C';
      record = '$input °F → ${result.toStringAsFixed(2)} °C';
    }

    setState(() {
      _conversionHistory.insert(0, record); // Add to top of list
    });
  }

//Adjusting to both lanscape and portrait
  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

//Appbar
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Temperature Converter',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
        elevation: 6,
        shadowColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isPortrait ? _buildVerticalLayout() : _buildHorizontalLayout(),
      ),
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildChildren(),
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
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shadowColor: Colors.blue,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _convertTemperature,
        child: const Text('Convert'),
      ),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.lightBlue[50],
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.blueAccent,
              offset: Offset(2, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Text(
          _convertedValue,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 20),
      const Text(
        'Conversion History:',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: _conversionHistory.isEmpty
              ? const Center(child: Text('No conversions yet.'))
              : ListView.builder(
                  itemCount: _conversionHistory.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(_conversionHistory[index]),
                  ),
                ),
        ),
      ),
    ];
  }
}
