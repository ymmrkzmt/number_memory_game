import 'package:flutter/material.dart';
import 'mode_select_screen.dart';
import 'game_screen.dart';
import '../services/score_manager.dart'; // ✅ スコア管理をインポート

class ResultScreen extends StatelessWidget {
  final String userAnswer;
  final String correctAnswer;
  final String mode;
  final String difficulty;

  const ResultScreen({
    required this.userAnswer,
    required this.correctAnswer,
    required this.mode,
    required this.difficulty,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCorrect = userAnswer == correctAnswer;

    if (isCorrect) {
      ScoreManager.increment(); // ✅ 正解ならスコア加算
    }

    return Scaffold(
      appBar: AppBar(title: Text('結果')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('あなたの答え: $userAnswer', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text('正解: $correctAnswer', style: TextStyle(fontSize: 24)),
            SizedBox(height: 32),
            Text(
              isCorrect ? '正解！🎉' : '不正解 😢',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isCorrect ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 24),
            Text('現在のスコア: ${ScoreManager.score}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
                      mode: mode,
                      difficulty: difficulty,
                    ),
                  ),
                );
              },
              child: Text('もう一度挑戦する'),
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                ScoreManager.reset(); // ✅ 戻るときにスコアリセット（任意）
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModeSelectScreen(),
                  ),
                  (route) => false,
                );
              },
              child: Text('モード選択に戻る'),
            ),
          ],
        ),
      ),
    );
  }
}