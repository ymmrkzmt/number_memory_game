import 'dart:math';
import 'package:flutter/material.dart';
import 'input_screen.dart';

/// 数字や電話番号を記憶するゲーム画面のWidget
class GameScreen extends StatefulWidget {
  /// ゲームモード ('phone' or 'number')
  final String mode; // 'phone' or 'number'
  /// 難易度 ('Easy', 'Normal', 'Hard')
  final String difficulty; // 'Easy', 'Normal', 'Hard'
  final int cumulativeScore;

  const GameScreen({
    required this.mode,
    required this.difficulty,
    required this.cumulativeScore,
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

  /// Stateの初期化を行い、難易度に応じた設定を適用し、値を生成する
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

  /// ランダムな電話番号を生成する
  String _generatePhoneNumber() {
    final rand = Random();
    final prefix = ['090', '080', '070'][rand.nextInt(3)];
    final mid = (1000 + rand.nextInt(9000)).toString();
    final last = (1000 + rand.nextInt(9000)).toString();
    return '$prefix-$mid-$last';
  }

  /// 難易度に応じた桁数のランダムな数字を生成する
  String _generateNumber() {
    final rand = Random();
    String result = '';
    for (int i = 0; i < digitCount; i++) {
      result += rand.nextInt(10).toString();
    }
    return result;
  }

  /// ゲームモードに応じて記憶する値を生成し、一定時間表示した後に回答画面へ遷移する
  void generateValue() {
    if (widget.mode == 'phone') {
      valueToRemember = _generatePhoneNumber();
    } else if (widget.mode == 'number') {
      valueToRemember = _generateNumber();
    } else {
      throw Exception('Unsupported mode: ${widget.mode}');
    }

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
              difficulty: widget.difficulty, // ✅ 難易度を渡す
              cumulativeScore: widget.cumulativeScore,
            ),
          ),
        );
      });
    });
  }

  /// 記憶する値を表示するUIを構築する
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
