import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:trilix/utils/colors.dart';
import 'package:trilix/utils/dimensions.dart';
import 'package:trilix/utils/widgets/big_text.dart';
import 'package:trilix/utils/widgets/icon_and_text_widget.dart';
import 'package:trilix/utils/widgets/small_text.dart';

class AppColumn extends StatelessWidget {
  final String text;
  const AppColumn({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      BigText(
        text: text,
        size: Dimentions.fontSize26,
      ),
      SizedBox(
        height: Dimentions.height10,
      ),
      Row(
        children: [
          Wrap(
            children: List.generate(
                5,
                (index) => Icon(
                      Icons.star,
                      color: AppColors.mainColor,
                      size: Dimentions.height15,
                    )),
          ),
          SizedBox(
            width: Dimentions.height10,
          ),
          SmallText(text: "4.5"),
          SizedBox(
            width: Dimentions.height10,
          ),
          SmallText(text: "1287"),
          SizedBox(
            width: 5,
          ),
          SmallText(text: "comments"),
        ],
      ),
      SizedBox(
        height: Dimentions.height20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconAndTextWidget(
              icon: Icons.circle_sharp,
              text: "Normal",
              iconColor: AppColors.iconColor1),
          IconAndTextWidget(
              icon: Icons.location_on,
              text: "1.7km",
              iconColor: AppColors.mainColor),
          IconAndTextWidget(
              icon: Icons.access_time_rounded,
              text: "4 Days",
              iconColor: AppColors.iconColor2)
        ],
      )
    ]);
  }
}
