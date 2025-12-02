import 'package:flutter/material.dart';
import 'screens/mode_select_screen.dart';
import 'package:flutter/foundation.dart'; // kIsWeb を使うために必要
import 'dart:html' as html; // Webでのみ利用可能なライブラリ

// Google Tagを初期化する関数
void initializeGoogleTag() {
  // Webプラットフォームで実行されている場合のみ処理を行う
  if (kIsWeb) {
    // --dart-defineで渡された'GOOGLE_TAG_ID'を取得
    const googleTagId = String.fromEnvironment('GOOGLE_TAG_ID');

    // GOOGLE_TAG_IDが設定されていない場合は何もしない
    if (googleTagId.isEmpty) {
      print('Google Tag ID is not defined.');
      return;
    }

    // gtag.jsを読み込むためのscriptタグを作成
    final script = html.ScriptElement()
      ..async = true
      ..src = 'https://www.googletagmanager.com/gtag/js?id=$googleTagId';

    // gtagを初期化するためのインラインscriptを作成
    final inlineScript = html.ScriptElement()
      ..text = '''
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
        gtag('config', '$googleTagId');
      ''';

    // 作成したscriptタグを<head>の末尾に追加
    html.document.head?.append(script);
    // 作成したインラインscriptを<head>の末尾に追加
    html.document.head?.append(inlineScript);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeGoogleTag();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '記憶ゲーム',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ModeSelectScreen(), // ✅ 最初に表示する画面
    );
  }
}
