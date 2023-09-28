import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:trilix/utils/dimensions.dart';
import 'package:trilix/utils/widgets/app_column.dart';
import 'package:trilix/utils/widgets/big_text.dart';
import 'package:trilix/utils/widgets/icon_and_text_widget.dart';
import 'package:trilix/utils/widgets/small_text.dart';

import '../../utils/colors.dart';

class TravelPageBody extends StatefulWidget {
  const TravelPageBody({super.key});

  @override
  State<TravelPageBody> createState() => _TravelPageBodyState();
}

class _TravelPageBodyState extends State<TravelPageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = Dimentions.pageViewContainer;
  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Slider section
        Container(
          height: Dimentions.pageView,
          child: PageView.builder(
              itemCount: 3,
              controller: pageController,
              itemBuilder: (context, position) {
                return _buildPageItem(position);
              }),
        ),
        //dots

        SizedBox(
          height: Dimentions.height30,
        ),
        //popular section
        Container(
          margin: EdgeInsets.only(left: Dimentions.height30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BigText(text: "Popular"),
              SizedBox(
                width: Dimentions.height10,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 3),
                child: BigText(
                  text: ".",
                  color: Colors.black26,
                ),
              ),
              SizedBox(
                width: Dimentions.height10,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 2),
                child: SmallText(text: "Places to visit"),
              )
            ],
          ),
        ),
        //list of places and images
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(
                    left: Dimentions.height20,
                    right: Dimentions.height20,
                    bottom: Dimentions.height10),
                child: Row(children: [
                  //images
                  Container(
                    height: Dimentions.height120,
                    width: Dimentions.height120,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimentions.height20),
                        color: Colors.white38,
                        image: DecorationImage(
                            image: AssetImage("assets/images/leh.jpg"),
                            fit: BoxFit.cover)),
                  ),
                  //text Container
                  Expanded(
                    child: Container(
                      height: Dimentions.height100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(Dimentions.height20),
                              bottomRight:
                                  Radius.circular(Dimentions.height20))),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: Dimentions.height10,
                            right: Dimentions.height10,
                            top: Dimentions.height15,
                            bottom: Dimentions.height15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BigText(text: "Parthasarathy Temple | Chennei"),
                            SmallText(
                                text: "Narayana Krishnaraja Puram, Triplicane"),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              );
            }),
      ],
    );
  }

  Widget _buildPageItem(int index) {
    Matrix4 matrix = new Matrix4.identity();
    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - currScale) / 2, 2);
    }
    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          Container(
            height: Dimentions.pageViewContainer,
            margin: EdgeInsets.only(
                left: Dimentions.height10, right: Dimentions.height10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimentions.height30),
                color: index.isEven ? Color(0xff69c5df) : Color(0xff9294cc),
                image: DecorationImage(
                    image: AssetImage("assets/images/patna.jpg"),
                    fit: BoxFit.cover)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Dimentions.pageTextContainer,
              margin: EdgeInsets.only(
                  left: Dimentions.height30,
                  right: Dimentions.height30,
                  bottom: Dimentions.height30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimentions.height20),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xffe8e8e8),
                        blurRadius: 5.0,
                        offset: Offset(0, 5)),
                    BoxShadow(color: Colors.white, offset: Offset(-5, 0)),
                    BoxShadow(color: Colors.white, offset: Offset(5, 0))
                  ],
                  color: Colors.white),
              child: Container(
                padding: EdgeInsets.only(
                    top: Dimentions.height15,
                    left: Dimentions.height15,
                    right: Dimentions.height15),
                child: AppColumn(
                  text: "Patna",
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
