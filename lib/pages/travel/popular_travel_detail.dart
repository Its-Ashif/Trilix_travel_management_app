import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:trilix/utils/colors.dart';
import 'package:trilix/utils/dimensions.dart';
import 'package:trilix/utils/widgets/app_column.dart';
import 'package:trilix/utils/widgets/app_icon.dart';
import 'package:trilix/utils/widgets/expandable_text.dart';
import 'package:trilix/utils/widgets/icon_and_text_widget.dart';
import 'package:trilix/utils/widgets/small_text.dart';

import '../../utils/widgets/big_text.dart';

class PopularTravelDetail extends StatelessWidget {
  final String description;
  final String photoURL;
  final int star;
  final String distance;

  const PopularTravelDetail({
    super.key,
    required this.description,
    required this.photoURL,
    required this.star,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        //background Image
        Positioned(
          left: 0,
          right: 0,
          child: Container(
            width: double.maxFinite,
            height: Dimentions.height350,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/patna.jpg"),
                    fit: BoxFit.cover)),
          ),
        ),
        //AppBar Logos
        Positioned(
          top: Dimentions.height45,
          left: Dimentions.height20,
          right: Dimentions.height20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppIcon(icon: Icons.arrow_back_ios),
              AppIcon(
                icon: Icons.shopping_cart_outlined,
              )
            ],
          ),
        ),
        //Container after the image
        Positioned(
            left: 0,
            right: 0,
            top: Dimentions.height350 - 20,
            bottom: 0,
            child: Container(
                padding: EdgeInsets.only(
                    left: Dimentions.height20,
                    right: Dimentions.height20,
                    top: Dimentions.height20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimentions.height20),
                        topRight: Radius.circular(Dimentions.height20)),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppColumn(
                      text: "Patna",
                    ),
                    SizedBox(
                      height: Dimentions.height20,
                    ),
                    BigText(text: "Descripton"),
                    SizedBox(
                      height: Dimentions.height20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: ExpandableText(
                            text:
                                "historically known as Pataliputra, is the capital and largest city of the state of Bihar in India. According to the United Nations, as of 2018, Patna had a population of 2.35 million, making it the 19th largest city in India. Covering 250 square kilometres (97 sq mi) and over 2.5 million people, its urban agglomeration is the 18th largest in India. Patna serves as the seat of Patna High Court. The Buddhist, Hindu and Jain pilgrimage centres of Vaishali, Rajgir, Nalanda, Bodh Gaya and Pawapuri are nearby and Patna City is a sacred city for Sikhs as the tenth Sikh Guru, Guru Gobind Singh was born here. The modern city of Patna is mainly on the southern bank of the river Ganges. The city also straddles the rivers Sone, Gandak and Punpun. The city is approximately 35 kilometres (22 mi) in length and 16 to 18 kilometres (9.9 to 11.2 mi) wide."),
                      ),
                    )
                  ],
                )))
      ]),
      bottomNavigationBar: Container(
        height: Dimentions.height120,
        padding: EdgeInsets.only(
            top: Dimentions.height30,
            bottom: Dimentions.height30,
            left: Dimentions.height20,
            right: Dimentions.height20),
        decoration: BoxDecoration(
            color: AppColors.buttonBackgroundColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimentions.height20 * 2),
                topRight: Radius.circular(Dimentions.height20 * 2))),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            padding: EdgeInsets.all(Dimentions.height20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimentions.height20),
                color: Colors.white),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.remove,
                    color: AppColors.signColor,
                  ),
                  SizedBox(
                    width: Dimentions.height10 / 2,
                  ),
                  BigText(text: "0"),
                  SizedBox(
                    width: Dimentions.height10 / 2,
                  ),
                  Icon(
                    Icons.add,
                    color: AppColors.signColor,
                  ),
                ]),
          ),
          Container(
            padding: EdgeInsets.all(Dimentions.height20),
            child: BigText(
              text: "\₹ 1245 | Add to cart",
              color: Colors.white,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimentions.height20),
                color: AppColors.mainColor),
          )
        ]),
      ),
    );
  }
}
