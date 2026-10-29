import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef NumpadCallback = void Function(String value);

class CustomNumpad extends StatelessWidget {
  final NumpadCallback onKey;
  final VoidCallback onDelete;
  final VoidCallback onDone;
  const CustomNumpad({Key? key, required this.onKey, required this.onDelete, required this.onDone}) : super(key: key);

  Widget _button(String label, {Color? color}) => InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onKey(label);
        },
        child: Center(child: Text(label, style: TextStyle(fontSize: 22, color: color ?? Colors.black))),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 2.2,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _button('1'),
          _button('2'),
          _button('3'),
          _button('4'),
          _button('5'),
          _button('6'),
          _button('7'),
          _button('8'),
          _button('9'),
          _button('.'),
          _button('0'),
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onDelete();
            },
            child: const Center(child: Icon(Icons.backspace)),
          ),
        ],
      ),
    );
  }
}
