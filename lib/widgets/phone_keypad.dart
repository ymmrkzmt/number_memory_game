import 'package:flutter/material.dart';

/// 電話のテンキー風のカスタムキーパッドWidget
class PhoneKeypad extends StatefulWidget {
  /// 数字ボタンが押されたときのコールバック
  final void Function(String digit) onDigitPressed;

  /// 削除ボタンが押されたときのコールバック
  final VoidCallback onDelete;

  /// 送信(OK)ボタンが押されたときのコールバック
  final VoidCallback onSubmit;

  const PhoneKeypad({
    required this.onDigitPressed,
    required this.onDelete,
    required this.onSubmit,
    super.key,
  });

  @override
  _PhoneKeypadState createState() => _PhoneKeypadState();
}

/// PhoneKeypadの状態を管理するStateクラス
class _PhoneKeypadState extends State<PhoneKeypad> {
  /// 押されているキーのラベルを保持する
  String? pressedKey;

  /// キーが押されたときの処理。UIのフィードバックとコールバックの呼び出しを行う
  void _handlePress(String label) {
    setState(() => pressedKey = label);

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() => pressedKey = null);
    });

    if (label == '←') {
      widget.onDelete();
    } else if (label == 'OK') {
      widget.onSubmit();
    } else {
      widget.onDigitPressed(label);
    }
  }

  /// ボタンのラベルに応じて色を返す
  Color _getButtonColor(String label) {
    if (label == '←') return Colors.red.shade300;
    if (label == 'OK') return Colors.green.shade400;
    return Colors.blue.shade300;
  }

  /// キーパッドのUIを構築する
  @override
  Widget build(BuildContext context) {
    final rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['←', '0', 'OK'],
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((label) {
            final isPressed = pressedKey == label;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedScale(
                scale: isPressed ? 0.9 : 1.0,
                duration: Duration(milliseconds: 100),
                child: SizedBox(
                  width: 80,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getButtonColor(label),
                    ),
                    onPressed: () => _handlePress(label),
                    child: Text(
                      label,
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
