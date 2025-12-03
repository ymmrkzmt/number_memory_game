import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_screen.dart';
import 'settings_screen.dart';
import '../services/score_manager.dart';
import '../widgets/score_history_list.dart';

class ModeSelectScreen extends StatefulWidget {
  // StatefulWidgetに変更
  const ModeSelectScreen({super.key});

  @override
  _ModeSelectScreenState createState() => _ModeSelectScreenState();
}

/// ModeSelectScreenの状態を管理するStateクラス
class _ModeSelectScreenState extends State<ModeSelectScreen> {
  String difficulty = 'Normal';

  /// Stateの初期化を行い、保存されている難易度を読み込む
  @override
  void initState() {
    super.initState();
    _loadDifficulty();
  }

  /// SharedPreferencesから難易度を読み込み、Stateを更新する
  Future<void> _loadDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('difficulty');
    if (saved != null) {
      setState(() => difficulty = saved);
      print('[ModeSelectScreen] 保存された難易度を読み込み: $difficulty');
    }
  }

  /// 設定画面を開き、戻ってきた際にUIを更新する
  void _openSettings() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );

    // 設定画面から戻ってきたときにUIを更新する
    setState(() {
      // Note: difficultyの更新は_loadDifficultyで行われる
    });

    if (result != null && result is String) {
      setState(() => difficulty = result);
      print('[ModeSelectScreen] 難易度が更新されました: $difficulty');
    }
  }

  /// 指定されたモードでゲーム画面を開始する
  void _startGame(String mode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          mode: mode,
          difficulty: difficulty,
          cumulativeScore: 0,
        ),
      ),
    );
  }

  /// モード選択画面のUIを構築する
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('モード選択')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('現在の難易度: $difficulty', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(
                '最新のスコア: ${ScoreManager.scoreHistory.isNotEmpty ? ScoreManager.scoreHistory.first.score : 0}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ScoreHistoryList(scoreHistory: ScoreManager.scoreHistory),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _startGame('phone'),
              child: Text('電話番号モード'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _startGame('number'),
              child: Text('数字モード'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _openSettings,
              child: Text('設定変更'),
            ),
          ],
        ),
      ),
    );
  }
}
