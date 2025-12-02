import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('難易度を選択してください', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            RadioListTile<String>(
              title: Text('Easy'),
              value: 'Easy',
              groupValue: selectedDifficulty,
              onChanged: (value) {
                setState(() => selectedDifficulty = value!);
              },
            ),
            RadioListTile<String>(
              title: Text('Normal'),
              value: 'Normal',
              groupValue: selectedDifficulty,
              onChanged: (value) {
                setState(() => selectedDifficulty = value!);
              },
            ),
            RadioListTile<String>(
              title: Text('Hard'),
              value: 'Hard',
              groupValue: selectedDifficulty,
              onChanged: (value) {
                setState(() => selectedDifficulty = value!);
              },
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
          ],
        ),
      ),
    );
  }
}
