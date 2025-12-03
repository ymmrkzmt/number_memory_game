import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../services/score_manager.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedDifficulty = 'Normal'; // 初期値

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('設定変更')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('難易度を選択してください', style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              InkWell(
                onTap: () => setState(() => selectedDifficulty = 'Easy'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: 'Easy',
                      groupValue: selectedDifficulty,
                      onChanged: (value) {
                        setState(() => selectedDifficulty = value!);
                      },
                    ),
                    const Text('Easy'),
                  ],
                ),
              ),
              InkWell(
                onTap: () => setState(() => selectedDifficulty = 'Normal'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: 'Normal',
                      groupValue: selectedDifficulty,
                      onChanged: (value) {
                        setState(() => selectedDifficulty = value!);
                      },
                    ),
                    const Text('Normal'),
                  ],
                ),
              ),
              InkWell(
                onTap: () => setState(() => selectedDifficulty = 'Hard'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: 'Hard',
                      groupValue: selectedDifficulty,
                      onChanged: (value) {
                        setState(() => selectedDifficulty = value!);
                      },
                    ),
                    const Text('Hard'),
                  ],
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance(); // ✅ 追加
                  await prefs.setString(
                      'difficulty', selectedDifficulty); // ✅ 難易度を保存
                  print('[SettingsScreen] 難易度を保存: $selectedDifficulty');

                  Navigator.pop(context, selectedDifficulty); // 既存の戻り処理
                },
                child: Text('保存して戻る'),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: Text('確認'),
                        content: Text('本当にスコア履歴をリセットしますか？\nこの操作は元に戻せません。'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('キャンセル'),
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                          TextButton(
                            child: Text('リセットする',
                                style: TextStyle(color: Colors.red)),
                            onPressed: () async {
                              await ScoreManager.clearHistory();
                              Navigator.of(dialogContext).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('スコア履歴をリセットしました')));
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('スコア履歴をリセット'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
