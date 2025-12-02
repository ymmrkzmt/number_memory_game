import 'dart:math';
import 'package:flutter/material.dart';
import 'input_screen.dart';

class GameScreen extends StatefulWidget {
  final String mode;        // 'phone' or 'number'
  final String difficulty;  // 'Easy', 'Normal', 'Hard'

  const GameScreen({
    required this.mode,
    required this.difficulty,
    super.key,
  });

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String valueToRemember = '';
  bool showValue = false;

  late int digitCount;
  late Duration displayDuration;

  @override
  void initState() {
    super.initState();

    // 難易度に応じて桁数と表示時間を設定
    switch (widget.difficulty) {
      case 'Easy':
        digitCount = 3;
        displayDuration = Duration(seconds: 3);
        break;
      case 'Hard':
        digitCount = 6;
        displayDuration = Duration(seconds: 1);
        break;
      default:
        digitCount = 4;
        displayDuration = Duration(seconds: 2);
    }

    generateValue();
  }

  String _generatePhoneNumber() {
    final rand = Random();
    final prefix = ['090', '080', '070'][rand.nextInt(3)];
    final mid = (1000 + rand.nextInt(9000)).toString();
    final last = (1000 + rand.nextInt(9000)).toString();
    return '$prefix-$mid-$last';
  }

  String _generateNumber() {
    final rand = Random();
    String result = '';
    for (int i = 0; i < digitCount; i++) {
      result += rand.nextInt(10).toString();
    }
    return result;
  }

  void generateValue() {
    if (widget.mode == 'phone') {
      valueToRemember = _generatePhoneNumber();
    } else if (widget.mode == 'number') {
      valueToRemember = _generateNumber();
    } else {
      throw Exception('Unsupported mode: ${widget.mode}');
    }

    print('[GameScreen] 正解: $valueToRemember (mode: ${widget.mode}, difficulty: ${widget.difficulty})');

    setState(() => showValue = true);

    Future.delayed(displayDuration, () {
      setState(() => showValue = false);
      Future.delayed(Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InputScreen(
              correctAnswer: valueToRemember,
              mode: widget.mode,
            ),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: showValue ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          child: Text(
            valueToRemember,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}