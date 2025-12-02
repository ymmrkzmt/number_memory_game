import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_screen.dart';
import 'settings_screen.dart';
import '../services/score_manager.dart';

class ModeSelectScreen extends StatefulWidget {
  @override
  _ModeSelectScreenState createState() => _ModeSelectScreenState();
}

class _ModeSelectScreenState extends State<ModeSelectScreen> {
  String difficulty = 'Normal';

  @override
  void initState() {
    super.initState();
    _loadDifficulty();
  }

  Future<void> _loadDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('difficulty');
    if (saved != null) {
      setState(() => difficulty = saved);
      print('[ModeSelectScreen] 保存された難易度を読み込み: $difficulty');
    }
  }

  void _openSettings() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );

    if (result != null && result is String) {
      setState(() => difficulty = result);
      print('[ModeSelectScreen] 難易度が更新されました: $difficulty');
    }
  }

  void _startGame(String mode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          mode: mode,
          difficulty: difficulty,
        ),
      ),
    );
  }

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
            Text('現在のスコア: ${ScoreManager.score}',
                style: TextStyle(fontSize: 16)),
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
