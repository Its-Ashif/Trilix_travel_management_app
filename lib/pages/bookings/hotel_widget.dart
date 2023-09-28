import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:trilix/pages/bookings/booking_info.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:trilix/utils/colors.dart';
import 'package:trilix/utils/dimensions.dart';
import 'package:trilix/utils/widgets/big_text.dart';
import 'package:trilix/utils/widgets/small_text.dart';

class HotelWidget extends StatefulWidget {
  String hotelName;
  String hotelRating;
  String hotelAddress;
  String distance;
  String cost;
  String place;
  HotelWidget({
    super.key,
    required this.hotelName,
    required this.hotelRating,
    required this.hotelAddress,
    required this.cost,
    required this.distance,
    required this.place,
  });

  @override
  State<HotelWidget> createState() => _HotelWidgetState();
}

class _HotelWidgetState extends State<HotelWidget> {
  String hotel_Name = '';
  @override
  Widget build(BuildContext context) {
    int roomCount = (int.parse(peoplecountController.toString()) / 2).round();

    return GestureDetector(
      onTap: () {
        changeHotelStatus({'hotelName': widget.hotelName, 'cost': widget.cost});
        showBottomSheet<void>(
            elevation: 1,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.all(Dimentions.height20),
                margin: EdgeInsets.only(
                    top: Dimentions.height300 +
                        Dimentions.height200 +
                        Dimentions.height70 +
                        Dimentions.height10 -
                        1,
                    left: Dimentions.height20,
                    right: Dimentions.height20,
                    bottom: Dimentions.height30),
                height: double.maxFinite,
                width: double.maxFinite,
                child: Column(children: [
                  BigText(
                    text: 'You are booking ${widget.hotelName}',
                    size: Dimentions.fontSize16,
                  ),
                  BigText(
                    text:
                        'for $peoplecountController people which is total ₹ ${(int.parse(widget.cost) * ((DateTime.parse(enddate).difference(DateTime.parse(startdate)).inHours / 24).round() + 1)) * roomCount}',
                    size: Dimentions.fontSize16,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimentions.height20)),
                          primary: AppColors.bottomBarActiveColor),
                      onPressed: () {
                        setState(() {
                          hotel_Name = widget.hotelName;
                          hoteltotal = (int.parse(widget.cost) *
                                  ((DateTime.parse(enddate)
                                                  .difference(
                                                      DateTime.parse(startdate))
                                                  .inHours /
                                              24)
                                          .round() +
                                      1)) *
                              roomCount;
                        });

                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: BigText(
                        text: "Ok",
                        color: Colors.white,
                      )),
                ]),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimentions.height30)),
              );
            });
      },
      child: Container(
        margin: EdgeInsets.only(
            left: Dimentions.height20,
            right: Dimentions.height20,
            bottom: Dimentions.height20),
        width: double.maxFinite,
        height: Dimentions.height100 + Dimentions.height40,
        padding: EdgeInsets.all(Dimentions.height20),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 20.0,
                spreadRadius: 1,
                offset: Offset(0, 20),
              )
            ],
            borderRadius: BorderRadius.circular(Dimentions.height15),
            color: widget.hotelName == hotel_Name
                ? AppColors.bottomBarActiveColor
                : Colors.white),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BigText(
                text: '${widget.hotelName}',
                color: Colors.black,
              ),
              Row(
                children: [
                  BigText(
                    text: '₹ ${widget.cost}',
                    color: Colors.black,
                  ),
                  SmallText(
                    text: ' / night',
                    color: Colors.black54,
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: Dimentions.height5,
          ),
          SmallText(
            text: widget.hotelAddress,
            color: Colors.black54,
          ),
          SizedBox(
            height: Dimentions.height5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SmallText(
                text: '${widget.distance} from airport',
                color: Colors.black,
                size: Dimentions.height15,
              ),
              Row(
                children: [
                  Icon(
                    FluentIcons.star_12_filled,
                    size: Dimentions.height20,
                  ),
                  SizedBox(
                    width: Dimentions.height5,
                  ),
                  BigText(
                    text: widget.hotelRating,
                    size: Dimentions.height20,
                  )
                ],
              )
            ],
          )
        ]),
      ),
    );
    ;
  }
}
