import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:trilix/pages/bookings/booking_info.dart';
import 'package:trilix/pages/bookings/train_class_widget.dart';
import 'package:trilix/utils/colors.dart';
import 'package:trilix/utils/dimensions.dart';
import 'package:trilix/utils/widgets/big_text.dart';
import 'package:trilix/utils/widgets/small_text.dart';

class TrainReturnWidget extends StatefulWidget {
  String trainName;
  String trainNumber;
  String startTime;
  String endTime;
  String duration;
  String startStation;
  String endStation;
  String sl;
  String a3;
  String a2;
  String a1;
  TrainReturnWidget(
      {super.key,
      required this.trainName,
      required this.trainNumber,
      required this.startTime,
      required this.endTime,
      required this.duration,
      required this.startStation,
      required this.endStation,
      required this.sl,
      required this.a3,
      required this.a2,
      required this.a1});

  @override
  State<TrainReturnWidget> createState() => _TrainReturnWidgetState();
}

class _TrainReturnWidgetState extends State<TrainReturnWidget> {
  String train_Name = '';
  String class_Name = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: Dimentions.height20,
          right: Dimentions.height20,
          bottom: Dimentions.height20),
      width: double.maxFinite,
      height: Dimentions.height200 + Dimentions.height20,
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
          color: Colors.white),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BigText(
              text: widget.trainName,
              color: Colors.black,
            ),
            BigText(
              text: "#${widget.trainNumber}",
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
            SmallText(text: widget.startStation),
            SmallText(text: widget.endStation)
          ],
        ),
        SizedBox(
          height: Dimentions.height10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () {
                  changeReturnTrainStatus(widget.trainName, 'SL');
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
                              text: 'You are booking ${widget.trainName}',
                              size: Dimentions.fontSize16,
                            ),
                            BigText(
                              text:
                                  'SL Class for $peoplecountController people which is total ₹ ${int.parse(widget.sl) * int.parse(peoplecountController.toString())}',
                              size: Dimentions.fontSize16,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            Dimentions.height20)),
                                    primary: AppColors.bottomBarActiveColor),
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    train_Name = widget.trainName;
                                    class_Name = 'SL';
                                    returntotal = (int.parse(widget.sl) *
                                        int.parse(
                                            peoplecountController.toString()));
                                  });
                                },
                                child: BigText(
                                  text: "Ok",
                                  color: Colors.white,
                                )),
                          ]),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(Dimentions.height30)),
                        );
                      });
                },
                child: TrainClassWidget(
                    trainClass: "SL",
                    price: widget.sl,
                    color: train_Name == widget.trainName && class_Name == 'SL'
                        ? AppColors.bottomBarActiveColor
                        : Colors.white)),
            GestureDetector(
                onTap: () {
                  changeReturnTrainStatus(widget.trainName, '3A');
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
                              text: 'You are booking ${widget.trainName}',
                              size: Dimentions.fontSize16,
                            ),
                            BigText(
                              text:
                                  '3A Class for $peoplecountController people which is total ₹ ${int.parse(widget.a3) * int.parse(peoplecountController.toString())}',
                              size: Dimentions.fontSize16,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            Dimentions.height20)),
                                    primary: AppColors.bottomBarActiveColor),
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    train_Name = widget.trainName;
                                    class_Name = '3A';
                                    returntotal = (int.parse(widget.a3) *
                                        int.parse(
                                            peoplecountController.toString()));
                                  });
                                },
                                child: BigText(
                                  text: "Ok",
                                  color: Colors.white,
                                )),
                          ]),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(Dimentions.height30)),
                        );
                      });
                },
                child: TrainClassWidget(
                    trainClass: "3A",
                    price: widget.a3,
                    color: train_Name == widget.trainName && class_Name == '3A'
                        ? AppColors.bottomBarActiveColor
                        : Colors.white)),
            GestureDetector(
                onTap: () {
                  changeReturnTrainStatus(widget.trainName, '2A');
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
                              text: 'You are booking ${widget.trainName}',
                              size: Dimentions.fontSize16,
                            ),
                            BigText(
                              text:
                                  '2A Class for $peoplecountController people which is total ₹ ${int.parse(widget.a2) * int.parse(peoplecountController.toString())}',
                              size: Dimentions.fontSize16,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            Dimentions.height20)),
                                    primary: AppColors.bottomBarActiveColor),
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    train_Name = widget.trainName;
                                    class_Name = '2A';
                                    returntotal = (int.parse(widget.a2) *
                                        int.parse(
                                            peoplecountController.toString()));
                                  });
                                },
                                child: BigText(
                                  text: "Ok",
                                  color: Colors.white,
                                )),
                          ]),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(Dimentions.height30)),
                        );
                      });
                },
                child: TrainClassWidget(
                    trainClass: "2A",
                    price: widget.a2,
                    color: train_Name == widget.trainName && class_Name == '2A'
                        ? AppColors.bottomBarActiveColor
                        : Colors.white)),
            GestureDetector(
                onTap: () {
                  changeReturnTrainStatus(widget.trainName, '1A');
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
                              text: 'You are booking ${widget.trainName}',
                              size: Dimentions.fontSize16,
                            ),
                            BigText(
                              text:
                                  '1A Class for $peoplecountController people which is total ₹ ${int.parse(widget.a1) * int.parse(peoplecountController.toString())}',
                              size: Dimentions.fontSize16,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            Dimentions.height20)),
                                    primary: AppColors.bottomBarActiveColor),
                                onPressed: () {
                                  setState(
                                    () {
                                      train_Name = widget.trainName;
                                      class_Name = '1A';
                                      returntotal = (int.parse(widget.a1) *
                                          int.parse(peoplecountController
                                              .toString()));
                                    },
                                  );
                                  Navigator.pop(context);
                                },
                                child: BigText(
                                  text: "Ok",
                                  color: Colors.white,
                                )),
                          ]),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(Dimentions.height30)),
                        );
                      });
                },
                child: TrainClassWidget(
                    trainClass: "1A",
                    price: widget.a1,
                    color: train_Name == widget.trainName && class_Name == '1A'
                        ? AppColors.bottomBarActiveColor
                        : Colors.white)),
          ],
        ),
      ]),
    );
    ;
  }
}
