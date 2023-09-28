import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/cupertino.dart';

class SmallText extends StatelessWidget {
  final Color? color;
  final String text;
  double size;
  double height;
  SmallText(
      {super.key,
      this.color = const Color(0xffccc7c5),
      required this.text,
      this.size = 12,
      this.height = 1.2});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'Roboto', fontSize: size, color: color, height: height),
    );
  }
}
