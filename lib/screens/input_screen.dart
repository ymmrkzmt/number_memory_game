import 'dart:async';
import 'package:flutter/material.dart';
import 'package:number_memory_game/models/score_record.dart';
import 'package:number_memory_game/services/score_manager.dart';
import 'result_screen.dart';
import '../config/constants.dart';
import '../widgets/phone_keypad.dart';

class InputScreen extends StatefulWidget {
  final String correctAnswer;
  final String mode;
  final String difficulty;
  final int cumulativeScore;

  const InputScreen({
    required this.correctAnswer,
    required this.mode,
    required this.difficulty,
    required this.cumulativeScore,
    super.key,
  });

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _controller = TextEditingController();
  late Timer _timer;
  late int _timeLimit;
  late int _currentTime;

  /// Stateの初期化を行い、タイマーを設定・開始する
  @override
  void initState() {
    super.initState();
    _setTimer();
    _startTimer();
  }

  /// ゲームモードと難易度に応じて制限時間を設定する
  void _setTimer() {
    _timeLimit = widget.mode == 'phone'
        ? phoneModeTimeLimit
        : (numberModeTimeLimits[widget.difficulty] ??
            numberModeTimeLimits['Normal']!);
    _currentTime = _timeLimit;
  }

  /// 1秒ごとにカウントダウンするタイマーを開始する
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentTime == 0) {
        _submitAnswer();
      } else {
        setState(() => _currentTime--);
      }
    });
  }

  /// ユーザーの回答を検証し、結果を保存して結果画面に遷移する
  void _submitAnswer() {
    _timer.cancel();
    final userInput = _controller.text.trim();
    final isCorrect = userInput == widget.correctAnswer;
    final timeTaken = Duration(seconds: _timeLimit - _currentTime);
    int newCumulativeScore;

    if (isCorrect) {
      newCumulativeScore = widget.cumulativeScore + 1;
    } else {
      // 不正解の場合、これまでの連続正解数を記録として保存
      final record = ScoreRecord(
        mode: widget.mode,
        difficulty: widget.difficulty,
        score: widget.cumulativeScore, // 連続正解数をスコアとして記録
        time: timeTaken,
        dateTime: DateTime.now(),
      );
      ScoreManager.addScore(record);
      newCumulativeScore = 0; // 連続正解数をリセット
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          userAnswer: userInput,
          correctAnswer: widget.correctAnswer,
          // 表示用のダミーレコードを作成（保存はしない）
          record: ScoreRecord(
              mode: widget.mode,
              difficulty: widget.difficulty,
              score: isCorrect ? 1 : 0,
              time: timeTaken,
              dateTime: DateTime.now()),
          cumulativeScore: newCumulativeScore,
        ),
      ),
    );
  }

  /// [digit]をテキストフィールドの末尾に追加する（数字モード用）
  void _appendNumber(String digit) {
    _controller.text += digit;
  }

  /// テキストフィールドの最後の文字を削除する（数字モード用）
  void _deleteLastNumber() {
    if (_controller.text.isEmpty) return;
    _controller.text =
        _controller.text.substring(0, _controller.text.length - 1);
  }

  /// [digit]を電話番号形式でテキストフィールドに追加する
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

  /// 電話番号形式でフォーマットされたテキストフィールドから最後の数字を削除する
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

  /// Widgetが破棄される際にタイマーとコントローラーを解放する
  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// 入力画面のUIを構築する
  @override
  Widget build(BuildContext context) {
    final isPhoneMode = widget.mode == 'phone';

    return Scaffold(
      appBar: AppBar(
        title: Text('記憶した内容を入力'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: _currentTime / _timeLimit,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: TextField(
                controller: _controller,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: '記憶した内容を入力',
                  hintText: isPhoneMode ? '例: 090-1234-5678' : '例: 4821',
                ),
              ),
            ),
            PhoneKeypad(
              onDigitPressed: isPhoneMode ? _appendDigit : _appendNumber,
              onDelete: isPhoneMode ? _deleteLastDigit : _deleteLastNumber,
              onSubmit: _submitAnswer,
            ),
          ],
        ),
      ),
    );
  }
}
