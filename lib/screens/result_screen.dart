import 'package:flutter/material.dart';
import 'package:number_memory_game/models/score_record.dart';
import 'package:number_memory_game/utils/formatter.dart';
import 'mode_select_screen.dart';
import 'game_screen.dart';
import '../services/score_manager.dart';
import '../widgets/score_history_list.dart';

class ResultScreen extends StatefulWidget {
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final Duration timeTaken;
  final int cumulativeScore;
  final String mode;
  final String difficulty;

  const ResultScreen({
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.timeTaken,
    required this.cumulativeScore,
    required this.mode,
    required this.difficulty,
    super.key,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    final isCorrect = widget.isCorrect;
    final scoreHistory = ScoreManager.scoreHistory;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('結果'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('あなたの答え: ${widget.userAnswer}',
                    style: TextStyle(fontSize: 24)),
                SizedBox(height: 16),
                Text('正解: ${widget.correctAnswer}',
                    style: TextStyle(fontSize: 24)),
                SizedBox(height: 32),
                Text(
                  isCorrect ? '正解！🎉' : '不正解 😢',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                ),
                if (isCorrect && widget.cumulativeScore > 1)
                  Text(
                    '${widget.cumulativeScore}問連続正解！',
                    style:
                        TextStyle(fontSize: 20, color: Colors.orange.shade800),
                  ),
                SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('今回の記録',
                            style: Theme.of(context).textTheme.titleLarge),
                        SizedBox(height: 8),
                        Text('モード: ${widget.mode}'),
                        Text('難易度: ${widget.difficulty}'),
                        Text('タイム: ${TimeFormatter.format(widget.timeTaken)}'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ScoreHistoryList(scoreHistory: scoreHistory),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(
                          mode: widget.mode,
                          difficulty: widget.difficulty,
                          cumulativeScore: widget.cumulativeScore,
                        ),
                      ),
                    );
                  },
                  child: Text('もう一度挑戦する'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // 正解していて、連続スコアがある場合に履歴へ保存する
                    if (isCorrect && widget.cumulativeScore > 0) {
                      final finalRecord = ScoreRecord(
                        mode: widget.mode,
                        difficulty: widget.difficulty,
                        score: widget.cumulativeScore, // 最終的な連続正解数を保存
                        time: widget.timeTaken,
                        dateTime: DateTime.now(),
                      );
                      ScoreManager.addScore(finalRecord);
                    }

                    // モード選択画面に戻る
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
        ),
      ),
    );
  }
}
