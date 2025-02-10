import 'package:flutter/material.dart';

void main() {
  runApp( StringCalculatorApp());
}

class StringCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StringCalculatorScreen(),
    );
  }
}

class StringCalculatorScreen extends StatefulWidget {
  @override
  _StringCalculatorScreenState createState() => _StringCalculatorScreenState();
}

class _StringCalculatorScreenState extends State<StringCalculatorScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  void _calculateSum() {
      try {
        String input = _controller.text.trim();

        // Print raw input with ASCII values
        print('Raw input before processing: "$input"');

        // ✅ Replace BOTH real and escaped newlines
        input = input.replaceAll('\\n', ',');  // Handles escaped \n
        input = input.replaceAll('//;', ',');  // Handles escaped \n
        input = input.replaceAll(';', ',');  // Handles escaped \n
        input = input.replaceAll(RegExp(r'[\n\r]+'), ',');  // Handles actual \n or \r

        // Print processed input
        print('Processed input after replacing newlines: "$input"');

        // int sum = addAndCalculate("//;\n1;4"); // Call function with cleaned input
        int sum = addAndCalculate(input); // Call function with cleaned input

        setState(() {
          _result = 'Sum: $sum';
        });
      } catch (e) {
        print('_result: $e');
        setState(() {
          _result = e.toString();
        });
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('String Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(labelText: 'Enter numbers'),
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _calculateSum, child: Text('Calculate')),
            SizedBox(height: 10),
            Text(_result, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }


  int addAndCalculate(String numbers) {
    if (numbers.isEmpty) return 0;

    String delimiter = ','; // Default delimiter

    // Handle custom delimiter format: "//[delimiter]\n[numbers]"
    if (numbers.startsWith('//')) {
      var parts = numbers.split('\n');
      if (parts.length > 1) {
        delimiter = parts.first.substring(2); // Extract delimiter after "//"
        numbers = parts.sublist(1).join('\n'); // Keep only numbers part
      }
    }

    // Ensure real newline handling (escaped "\n" case is fixed)
    numbers = numbers.replaceAll(RegExp(r'\\n'), '\n'); // Convert escaped \n to real newlines
    numbers = numbers.replaceAll(RegExp(r'[\n\r]+'), delimiter); // Replace all newlines with the delimiter

    // Split numbers correctly using the detected delimiter
    List<String> numberList = numbers.split(delimiter);
    print('numberList: $numberList');

    List<int> negatives = [];
    int sum = 0;

    for (var num in numberList) {
      num = num.trim();
      if (num.isEmpty) continue;

      try {
        int value = int.parse(num);
        if (value < 0) {
          negatives.add(value);
        } else {
          sum += value;
        }
      } catch (e) {
        throw FormatException("Invalid number format: $num");
      }
    }

    if (negatives.isNotEmpty) {
      throw Exception('Negative numbers not allowed: ${negatives.join(', ')}');
    }

    return sum;
  }

}