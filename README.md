# number_memory_game

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 事前準備：Google Analyticsの設定

このプロジェクトでは、Google Analyticsによるアクセス解析を導入しています。
アプリケーションを実行またはビルドする際には、Google Tag IDを環境変数として指定する必要があります。

IDは`--dart-define`フラグを使用して設定します。

- **開発用ID**: 開発中のテストに使用します。
- **本番用ID**: 公開するアプリケーションに使用します。

これらのIDは、ご自身のGoogle Analyticsアカウントから取得してください。

## 動作確認

### 1. ローカルでの開発実行

以下のコマンドを実行すると、開発用にアプリケーションを起動できます。
Webで確認する場合は、`-d <device>` のようにデバイスを指定してください。

- Google Chrome: `chrome`
- Microsoft Edge: `edge`
- Apple Safari: `safari` (macOSのみ)

例えば、Chromeで開発用ID (`G-DEV1234567`の部分はご自身のIDに置き換えてください) を使って実行する場合は以下のようになります。

```bash
flutter run -d chrome --dart-define=GOOGLE_TAG_ID=G-DEV1234567
flutter run -d web-server --web-port=8080
```

利用可能なデバイスの一覧は `flutter devices` コマンドで確認できます。

### 2. Web用にビルドして確認

以下のコマンドで、Web用の資材をビルドします。

```bash
flutter build web
```

もし、Webサイトのルート (`/`) 以外にデプロイする場合 (例: `https://example.com/my-app/`) は、`--base-href` オプションでパスを指定する必要があります。

```bash
flutter build web --base-href /my-app/
```

ビルドされた資材は `build/web` ディレクトリに出力されます。
このディレクトリをWebサーバーに配置することで、アプリケーションを公開できます。

ローカルでビルドした資材の動作を確認するには、`build/web` ディレクトリで簡易的なWebサーバーを起動し、ブラウザでアクセスします。

```bash
# build/web ディレクトリに移動
cd build/web

# Python 3 を使って簡易サーバーを起動
python -m http.server 8000

# ブラウザで http://localhost:8000 にアクセス
```
