import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:trilix/pages/bookings/booking_info.dart';
import 'package:trilix/utils/colors.dart';
import 'package:trilix/utils/dimensions.dart';
import 'package:trilix/utils/widgets/big_text.dart';
import 'package:trilix/utils/widgets/small_text.dart';

class PlaneReturnWidget extends StatefulWidget {
  String planeName;
  String planeNumber;
  String startTime;
  String endTime;
  String destination;
  String duration;
  String cost;
  PlaneReturnWidget(
      {super.key,
      required this.planeName,
      required this.planeNumber,
      required this.startTime,
      required this.endTime,
      required this.duration,
      required this.destination,
      required this.cost});

  @override
  State<PlaneReturnWidget> createState() => _PlaneReturnWidgetState();
}

class _PlaneReturnWidgetState extends State<PlaneReturnWidget> {
  String plane_Name = '';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        changeReturnPlaneStatus(widget.planeName);
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
                    text: 'You are booking ${widget.planeName}',
                    size: Dimentions.fontSize16,
                  ),
                  BigText(
                    text:
                        'for $peoplecountController people which is total ₹ ${int.parse(widget.cost) * int.parse(peoplecountController.toString())}',
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
                          plane_Name = widget.planeName;
                          returntotal = (int.parse(widget.cost) *
                              int.parse(peoplecountController.toString()));
                        });

                        Navigator.pop(context);
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
        height: Dimentions.height100 + Dimentions.height20,
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
            color: widget.planeName == plane_Name
                ? AppColors.bottomBarActiveColor
                : Colors.white),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BigText(
                text: widget.planeName,
                color: Colors.black,
              ),
              BigText(
                text: '₹ ${widget.cost}',
                color: Colors.black,
              ),
              BigText(
                text: "#${widget.planeNumber}",
                color: Colors.black,
              )
            ],
          ),
          SizedBox(
            height: Dimentions.height10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SmallText(
                text: widget.startTime,
                color: Colors.black,
              ),
              Container(
                width: Dimentions.height70,
                height: 3,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(Dimentions.height30)),
              ),
              SmallText(text: widget.duration),
              Container(
                width: Dimentions.height70,
                height: 3,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(Dimentions.height30)),
              ),
              SmallText(
                text: widget.endTime,
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(
            height: Dimentions.height5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SmallText(text: widget.destination),
              SmallText(text: 'Kolkata')
            ],
          ),
          SizedBox(
            height: Dimentions.height10,
          ),
        ]),
      ),
    );
  }
}
