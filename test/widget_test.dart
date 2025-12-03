// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_memory_game/main.dart';
import 'package:number_memory_game/screens/game_screen.dart';
import 'package:number_memory_game/screens/input_screen.dart';
import 'package:number_memory_game/screens/mode_select_screen.dart';
import 'package:number_memory_game/screens/result_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Widgetテストのエントリーポイント
void main() {
  // SharedPreferencesのモックをセットアップ
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Number mode game flow smoke test', (WidgetTester tester) async {
    // 1. アプリを起動し、UIが安定するまで待つ
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // 2. モード選択画面が表示されていることを確認
    expect(find.byType(ModeSelectScreen), findsOneWidget);
    expect(find.text('数字モード'), findsOneWidget);
    expect(find.text('電話番号モード'), findsOneWidget);

    // 3. 「数字モード」ボタンをタップしてゲームを開始
    await tester.tap(find.text('数字モード'));
    // 画面遷移のアニメーションが完了するまで待つ
    await tester.pumpAndSettle();

    // 4. ゲーム画面が表示され、数字が表示されることを確認
    expect(find.byType(GameScreen), findsOneWidget);
    // 数字が表示されるのを待つ (表示時間は難易度によるが、最大3秒 + 遷移時間)
    await tester.pump(const Duration(seconds: 4));
    // 入力画面への遷移が完了するまで待つ
    await tester.pumpAndSettle();

    // 5. 入力画面が表示されていることを確認
    expect(find.byType(InputScreen), findsOneWidget);

    // 6. キーパッドで数字を入力する
    await tester.tap(find.text('1'));
    await tester.pump();
    await tester.tap(find.text('2'));
    await tester.pump();
    await tester.tap(find.text('3'));
    await tester.pump();

    // 7. 「OK」ボタンをタップして回答を送信
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // 8. 結果画面に遷移し、結果が表示されていることを確認
    expect(find.byType(ResultScreen), findsOneWidget);
    // このテストでは正解は不明なため、「正解」または「不正解」のいずれかが表示されることを確認
    expect(
        find.byWidgetPredicate((widget) =>
            widget is Text &&
            (widget.data!.contains('正解！🎉') ||
                widget.data!.contains('不正解 😢'))),
        findsOneWidget);
  });
}
