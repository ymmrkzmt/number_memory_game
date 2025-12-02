import 'package:flutter/material.dart';
import 'result_screen.dart';
import '../widgets/phone_keypad.dart';

class InputScreen extends StatefulWidget {
  final String correctAnswer;
  final String mode;

  const InputScreen({
    required this.correctAnswer,
    required this.mode,
    super.key,
  });

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _controller = TextEditingController();

  void _submitAnswer() {
    final userInput = _controller.text.trim();
    if (userInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('入力が空です')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          userAnswer: userInput,
          correctAnswer: widget.correctAnswer,
          mode: widget.mode,
          difficulty: 'Normal', // 必要に応じて渡す
        ),
      ),
    );
  }

  void _appendDigit(String digit) {
    String current = _controller.text.replaceAll('-', '');
    if (current.length >= 11) return;

    current += digit;

    String formatted = '';
    for (int i = 0; i < current.length; i++) {
      formatted += current[i];
      if (i == 2 || i == 6) formatted += '-';
    }

    _controller.text = formatted;
  }

  void _deleteLastDigit() {
    String current = _controller.text.replaceAll('-', '');
    if (current.isEmpty) return;

    current = current.substring(0, current.length - 1);

    String formatted = '';
    for (int i = 0; i < current.length; i++) {
      formatted += current[i];
      if (i == 2 || i == 6) formatted += '-';
    }

    _controller.text = formatted;
  }

  @override
  Widget build(BuildContext context) {
    final isPhoneMode = widget.mode == 'phone';

    return Scaffold(
      appBar: AppBar(title: Text('記憶した内容を入力')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: TextField(
                controller: _controller,
                readOnly: isPhoneMode,
                decoration: InputDecoration(
                  labelText: '記憶した内容を入力',
                  hintText: isPhoneMode ? '例: 090-1234-5678' : '例: 4821',
                ),
              ),
            ),
            if (isPhoneMode)
              PhoneKeypad(
                onDigitPressed: _appendDigit,
                onDelete: _deleteLastDigit,
                onSubmit: _submitAnswer,
              )
            else
              ElevatedButton(
                onPressed: _submitAnswer,
                child: Text('確認'),
              ),
          ],
        ),
      ),
    );
  }
}