import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:trilix/utils/dimensions.dart';

class BigText extends StatelessWidget {
  final Color? color;
  final String text;
  double size;
  TextOverflow overFlow;
  BigText(
      {super.key,
      this.color = const Color(0xff332d2b),
      required this.text,
      this.size = 0,
      this.overFlow = TextOverflow.ellipsis});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overFlow,
      style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: size == 0 ? Dimentions.height20 : size,
          color: color,
          fontWeight: FontWeight.bold),
    );
  }
}
