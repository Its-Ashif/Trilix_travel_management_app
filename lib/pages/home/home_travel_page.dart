import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:trilix/pages/home/travel_page_body.dart';
import 'package:trilix/utils/colors.dart';

import '../../utils/widgets/big_text.dart';
import '../../utils/widgets/small_text.dart';

class MainTravelPage extends StatefulWidget {
  const MainTravelPage({super.key});

  @override
  State<MainTravelPage> createState() => _MainTravelPageState();
}

class _MainTravelPageState extends State<MainTravelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          child: Container(
            margin: EdgeInsets.only(top: 45, bottom: 15),
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      BigText(
                        text: "West Bengal",
                        color: AppColors.mainColor,
                      ),
                      Row(
                        children: [
                          SmallText(
                            text: "Kolkata",
                            color: Colors.black54,
                          ),
                          Icon(Icons.arrow_drop_down_rounded)
                        ],
                      )
                    ],
                  ),
                  Center(
                    child: Container(
                      height: 45,
                      width: 45,
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.mainColor),
                    ),
                  )
                ]),
          ),
        ),
        Expanded(
            child: SingleChildScrollView(
          child: TravelPageBody(),
        )),
      ]),
    );
  }
}
