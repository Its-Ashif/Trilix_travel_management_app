import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:trilix/utils/dimensions.dart';
import 'package:trilix/utils/widgets/big_text.dart';

class TrainClassWidget extends StatelessWidget {
  String trainClass;
  String price;
  Color color;
  TrainClassWidget(
      {super.key,
      required this.trainClass,
      required this.price,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimentions.height60,
      width: Dimentions.height60,
      padding: EdgeInsets.all(Dimentions.height5),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 20.0,
              spreadRadius: 1,
              offset: Offset(0, 20),
            )
          ],
          borderRadius: BorderRadius.circular(
            Dimentions.height15,
          ),
          color: color),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        BigText(
          text: trainClass,
          size: Dimentions.height20,
        ),
        BigText(
          text: "₹ $price",
          size: Dimentions.height15,
        )
      ]),
    );
  }
}
