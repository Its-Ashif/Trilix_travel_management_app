import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:trilix/data/place_data.dart';
import 'package:trilix/pages/bookings/order_history.dart';
import 'package:trilix/pages/home/travel_detail.dart';
import 'package:trilix/utils/colors.dart';
import 'package:trilix/utils/dimensions.dart';
import 'package:trilix/utils/widgets/big_text.dart';
import 'package:trilix/utils/widgets/small_text.dart';

class BookingsDetail extends StatefulWidget {
  const BookingsDetail({super.key});

  @override
  State<BookingsDetail> createState() => _BookingsDetailState();
}

enum ShowStateWidget {
  SHOW_UPCOMING_TRIP,
  SHOW_COMPLETED_TRIP,
  SHOW_CANCELLED_TRIP,
}

bool isUpcomingData = false;
Map<String, dynamic>? data;

showUpcomingWidget(context) {}

class _BookingsDetailState extends State<BookingsDetail> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> getOrderData() async {
      final _auth = FirebaseAuth.instance;
      CollectionReference users =
          FirebaseFirestore.instance.collection('orders');
      final snapshot = await users.doc(_auth.currentUser?.uid).get();

      if (snapshot.exists) {
        if (this.mounted) {
          setState(() {
            isUpcomingData = true;
            isLoading = false;
          });
        }
      } else {
        if (this.mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
      final data = snapshot.data() as Map<String, dynamic>;
      return data;
    }

    Future<void> _getOrderData() async {
      data = await getOrderData();
    }

    _getOrderData();

    return isLoading
        ? Center(
            child: CircularProgressIndicator(
                color: AppColors.bottomBarActiveColor),
          )
        : SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: Dimentions.height30,
                ),
                BigText(text: 'Booking History'),
                SizedBox(
                  height: Dimentions.height30,
                ),
                isUpcomingData
                    ? Container(
                        height: Dimentions.height350 +
                            Dimentions.height300 -
                            Dimentions.height10,
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: data!['orderHistory'].length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderHistoryDetial(
                                              placeName: data!['orderHistory'][index]
                                                  ['placeDetails']['placeName'],
                                              imageURL: data!['orderHistory'][index]
                                                  ['placeDetails']['imageURL'],
                                              hotelCost: data!['orderHistory']
                                                  [index]['hotel']['cost'],
                                              startdate: data!['orderHistory']
                                                      [index]['placeDetails']
                                                  ['startDate'],
                                              enddate: data!['orderHistory'][index]
                                                  ['placeDetails']['endDate'],
                                              peopleCount: data!['orderHistory']
                                                  [index]['peopleCount'],
                                              total: data!['orderHistory'][index]['placeDetails']['price'].toString(),
                                              deputureName: data!['orderHistory'][index]['depurtureName'],
                                              returnName: data!['orderHistory'][index]['returnName'],
                                              depurtureCost: data!['orderHistory'][index]['depurtureCost'],
                                              returnCost: data!['orderHistory'][index]['returnCost'],
                                              hotel: data!['orderHistory'][index]['hotel']['hotelName'])));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: Dimentions.height20,
                                      right: Dimentions.height20,
                                      bottom: Dimentions.height20),
                                  padding: EdgeInsets.all(Dimentions.height15),
                                  height: Dimentions.height150,
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 20.0,
                                          spreadRadius: 1,
                                          offset: Offset(0, 20),
                                        )
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          Dimentions.height15)),
                                  child: Row(children: [
                                    Container(
                                      width: Dimentions.height150,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  data!['orderHistory'][index]
                                                          ['placeDetails']
                                                      ['imageURL']),
                                              fit: BoxFit.cover),
                                          borderRadius: BorderRadius.circular(
                                              Dimentions.height15)),
                                    ),
                                    SizedBox(
                                      width: Dimentions.height10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BigText(
                                          text: data!['orderHistory'][index]
                                              ['placeDetails']['placeName'],
                                          size: Dimentions.fontSize16,
                                        ),
                                        SizedBox(
                                          height: Dimentions.height5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              FluentIcons.location_20_filled,
                                              size: Dimentions.height20,
                                              color: Colors.red,
                                            ),
                                            SizedBox(
                                              width: Dimentions.height5,
                                            ),
                                            SmallText(
                                                text: data!['orderHistory']
                                                        [index]['placeDetails']
                                                    ['placeName'])
                                          ],
                                        ),
                                        SizedBox(
                                          height: Dimentions.height5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              FluentIcons
                                                  .calendar_ltr_28_filled,
                                              size: Dimentions.height20,
                                              color: AppColors
                                                  .bottomBarActiveColor,
                                            ),
                                            SizedBox(
                                              width: Dimentions.height5,
                                            ),
                                            SmallText(
                                              text:
                                                  "${DateFormat.MMMd().format(DateTime.parse(data!['orderHistory'][index]['placeDetails']['startDate']))} - ${DateFormat.MMMd().format(DateTime.parse(data!['orderHistory'][index]['placeDetails']['endDate']))}",
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: Dimentions.height5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              FluentIcons.money_hand_20_filled,
                                              size: Dimentions.height20,
                                              color: Color(0xfffaa504),
                                            ),
                                            SizedBox(
                                              width: Dimentions.height5,
                                            ),
                                            SmallText(
                                                text: data!['orderHistory']
                                                                [index]
                                                            ['placeDetails']
                                                        ['price']
                                                    .toString())
                                          ],
                                        ),
                                      ],
                                    )
                                  ]),
                                ),
                              );
                            }),
                      )
                    : Center(
                        child: BigText(
                        text: "You have no order history",
                      ))
              ],
            ),
          );
  }
}
