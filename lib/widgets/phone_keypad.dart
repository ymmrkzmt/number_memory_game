import 'package:flutter/material.dart';

class PhoneKeypad extends StatefulWidget {
  final void Function(String digit) onDigitPressed;
  final VoidCallback onDelete;
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

class _PhoneKeypadState extends State<PhoneKeypad> {
  String? pressedKey;

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

  Color _getButtonColor(String label) {
    if (label == '←') return Colors.red.shade300;
    if (label == 'OK') return Colors.green.shade400;
    return Colors.blue.shade300;
  }

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