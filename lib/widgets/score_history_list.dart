import 'package:flutter/material.dart';
import '../models/score_record.dart';
import 'package:intl/intl.dart';

/// スコア履歴を表示するための共通Widget
class ScoreHistoryList extends StatelessWidget {
  final List<ScoreRecord> scoreHistory;

  const ScoreHistoryList({required this.scoreHistory, super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('スコア履歴'),
      children: scoreHistory.isEmpty
          ? [
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('履歴がまだありません'),
              ))
            ]
          : [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        Theme.of(context).colorScheme.primary, // アプリのテーマカラーを使用
                  ),
                  headingRowColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                  columns: const [
                    DataColumn(label: Text('日付')),
                    DataColumn(label: Text('モード')),
                    DataColumn(label: Text('難易度')),
                    DataColumn(label: Text('正解数')),
                  ],
                  rows: scoreHistory.map((rec) {
                    final formattedDate =
                        DateFormat('yyyy/MM/dd HH:mm:ss').format(rec.dateTime);
                    return DataRow(
                      cells: [
                        DataCell(Text(formattedDate)),
                        DataCell(Text(rec.mode)),
                        DataCell(Text(rec.difficulty)),
                        DataCell(Text(
                          '${rec.score}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
    );
  }
}
