import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:number_memory_game/models/score_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// スコアを永続化し、アプリ全体で管理するクラス
class ScoreManager {
  static const String _scoreHistoryKey = 'score_history';
  static const int _maxHistory = 5;
  static late SharedPreferences _prefs;
  static List<ScoreRecord> _scoreHistory = [];

  /// アプリ起動時にスコアを初期化する
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // 過去のバージョンとの互換性のために、まずdynamic型でデータを取得
    final dynamic historyData = _prefs.get(_scoreHistoryKey);

    if (historyData is List<String>) {
      // 期待通りの形式(List<String>)の場合
      _scoreHistory = historyData
          .map((s) {
            try {
              final decoded = json.decode(s);
              if (decoded is Map<String, dynamic>) {
                return ScoreRecord.fromJson(decoded);
              }
            } catch (e) {
              debugPrint('スコア履歴のデコードに失敗: $s, エラー: $e');
            }
            return null;
          })
          .whereType<ScoreRecord>()
          .toList();
    } else {
      // 古い形式(List<int>など)や予期しないデータの場合は履歴をクリア
      _scoreHistory = [];
    }
  }

  /// スコア履歴のリストを取得する
  static List<ScoreRecord> get scoreHistory => _scoreHistory;

  /// スコアを履歴に追加する
  static Future<void> addScore(ScoreRecord record) async {
    _scoreHistory.insert(0, record);
    if (_scoreHistory.length > _maxHistory) {
      _scoreHistory.removeLast();
    }
    await _save();
  }

  /// スコアを永続化領域に保存する
  static Future<void> _save() async {
    final historyAsString =
        _scoreHistory.map((record) => json.encode(record.toJson())).toList();
    await _prefs.setStringList(_scoreHistoryKey, historyAsString);
  }

  /// スコア履歴をクリアする
  static Future<void> clearHistory() async {
    _scoreHistory.clear();
    await _prefs.remove(_scoreHistoryKey);
  }
}
