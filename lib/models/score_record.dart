import 'package:flutter/foundation.dart';

@immutable

/// 1回のゲーム結果を保持する不変クラス
class ScoreRecord {
  const ScoreRecord({
    required this.mode,
    required this.difficulty,
    required this.score,
    required this.time,
    required this.dateTime,
  });

  /// ゲームモード ('phone' または 'number')
  final String mode;

  /// 難易度 ('Easy', 'Normal', 'Hard')
  final String difficulty;

  /// スコア (正解: 1, 不正解: 0)
  final int score;

  /// 回答にかかった時間
  final Duration time;

  /// 記録日時
  final DateTime dateTime;

  /// ScoreRecordオブジェクトをJSON形式のMapに変換する
  Map<String, dynamic> toJson() {
    return {
      'mode': mode,
      'difficulty': difficulty,
      'score': score,
      'time': time.inMilliseconds,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  /// JSON形式のMapからScoreRecordオブジェクトを生成する
  factory ScoreRecord.fromJson(Map<String, dynamic> json) {
    return ScoreRecord(
      mode: json['mode'] as String,
      difficulty: json['difficulty'] as String,
      score: json['score'] as int,
      time: Duration(milliseconds: json['time'] as int),
      dateTime: DateTime.parse(json['dateTime'] as String),
    );
  }
}
