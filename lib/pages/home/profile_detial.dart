// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sizer/sizer.dart';
import 'package:trilix/data/firebase/get_data.dart';
import 'package:trilix/pages/auth/login_page.dart';
import 'package:trilix/pages/bookings/order_history.dart';
import 'package:trilix/pages/home/bookings_detail.dart';
import 'package:trilix/pages/home/profile_edit.dart';
import 'package:trilix/utils/colors.dart';
import 'package:trilix/utils/dimensions.dart';
import 'package:trilix/utils/widgets/big_text.dart';
import 'package:trilix/utils/widgets/small_text.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({super.key});

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

final _auth = FirebaseAuth.instance;
Map<String, dynamic> user_data = {};
Map<String, dynamic> order_data = {};
bool isOrder = false;
bool isLoading = true;

//defining the getdata funcit9on from database Service

class _ProfileDetailState extends State<ProfileDetail> {
  @override
  Widget build(BuildContext context) {
    //calling the function for the user data
    Future<void> getUserData() async {
      Map<String, dynamic> data = await DatabaseService().getUser();
      if (!mounted) {
        return;
      }
      setState(() {
        user_data = data;
      });
    }

    Future<void> getOrder() async {
      CollectionReference orders =
          await FirebaseFirestore.instance.collection('orders');
      final snapshot = await orders.doc(_auth.currentUser?.uid).get();
      if (snapshot.exists) {
        if (!mounted) {
          return;
        }
        setState(() {
          order_data = snapshot.data() as Map<String, dynamic>;
          isOrder = true;
          isLoading = false;
        });
      } else {
        if (!mounted) {
          return;
        }
        setState(() {
          isLoading = false;
        });
      }
    }

    getUserData();
    getOrder();

    return Scaffold(
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Container(
                margin: EdgeInsets.only(top: Dimentions.height40),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: BigText(
                          text: user_data['firstName'].toString() +
                              " " +
                              user_data['lastName'].toString(),
                          size: Dimentions.height20,
                        )),
                    SizedBox(
                      height: Dimentions.height10,
                    ),
                    Container(
                      height: Dimentions.height100,
                      width: Dimentions.height100,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimentions.height40),
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/profile${user_data['profileNo'].toString()}.png"),
                              fit: BoxFit.cover)),
                    ),
                    SizedBox(
                      height: Dimentions.height20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimentions.height20)),
                                primary: Color(0xff0195d1)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileEdit(
                                          user_data_edit: user_data)));
                            },
                            child: BigText(
                              text: "Edit Profile",
                              color: Colors.white,
                            )),
                        SizedBox(
                          width: Dimentions.height30,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimentions.height30),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimentions.height20)),
                                primary: Colors.red),
                            onPressed: () {
                              signOut();
                            },
                            child: BigText(
                              text: "Logout",
                              color: Colors.white,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: Dimentions.height20,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: Dimentions.height60,
                          right: Dimentions.height60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Icon(
                                FluentIcons.location_20_filled,
                                color: Colors.red,
                              ),
                              SizedBox(
                                height: Dimentions.height5,
                              ),
                              BigText(
                                text: "Kolkata",
                                size: Dimentions.height17,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                FluentIcons.vehicle_car_20_filled,
                                color: AppColors.bottomBarActiveColor,
                              ),
                              SizedBox(
                                height: Dimentions.height5,
                              ),
                              BigText(
                                text: isOrder
                                    ? "${order_data['orderHistory'].length} places"
                                    : "0 places",
                                size: Dimentions.height17,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                FluentIcons.phone_checkmark_16_filled,
                                color: Color(0xff0195d1),
                              ),
                              SizedBox(
                                height: Dimentions.height5,
                              ),
                              BigText(
                                text: "Verified",
                                size: Dimentions.height17,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Dimentions.height30,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: Dimentions.height20,
                        right: Dimentions.height20,
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: BigText(
                          text: "Recent Destinations.",
                          size: Dimentions.height20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimentions.height20,
                    ),
                    Container(
                      height: Dimentions.height350,
                      child: isOrder
                          ? ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: order_data['orderHistory'].length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OrderHistoryDetial(
                                                placeName: order_data['orderHistory']
                                                        [index]['placeDetails']
                                                    ['placeName'],
                                                imageURL: order_data['orderHistory']
                                                        [index]['placeDetails']
                                                    ['imageURL'],
                                                hotelCost: order_data['orderHistory']
                                                    [index]['hotel']['cost'],
                                                startdate: order_data['orderHistory']
                                                        [index]['placeDetails']
                                                    ['startDate'],
                                                enddate: order_data['orderHistory']
                                                        [index]['placeDetails']
                                                    ['endDate'],
                                                peopleCount: order_data['orderHistory'][index]['peopleCount'],
                                                total: order_data['orderHistory'][index]['placeDetails']['price'].toString(),
                                                deputureName: order_data['orderHistory'][index]['depurtureName'],
                                                returnName: order_data['orderHistory'][index]['returnName'],
                                                depurtureCost: order_data['orderHistory'][index]['depurtureCost'],
                                                returnCost: order_data['orderHistory'][index]['returnCost'],
                                                hotel: order_data['orderHistory'][index]['hotel']['hotelName'])));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: Dimentions.height20,
                                        right: Dimentions.height20,
                                        bottom: Dimentions.height20),
                                    padding:
                                        EdgeInsets.all(Dimentions.height15),
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
                                                    order_data['orderHistory']
                                                                [index]
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
                                            text: order_data['orderHistory']
                                                    [index]['placeDetails']
                                                ['placeName'],
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
                                                  text:
                                                      order_data['orderHistory']
                                                                  [index]
                                                              ['placeDetails']
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
                                                    "${DateFormat.MMMd().format(DateTime.parse(order_data['orderHistory'][index]['placeDetails']['startDate']))} - ${DateFormat.MMMd().format(DateTime.parse(order_data['orderHistory'][index]['placeDetails']['endDate']))}",
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
                                                FluentIcons
                                                    .money_hand_20_filled,
                                                size: Dimentions.height20,
                                                color: Color(0xfffaa504),
                                              ),
                                              SizedBox(
                                                width: Dimentions.height5,
                                              ),
                                              SmallText(
                                                  text:
                                                      order_data['orderHistory']
                                                                      [index][
                                                                  'placeDetails']
                                                              ['price']
                                                          .toString())
                                            ],
                                          ),
                                        ],
                                      )
                                    ]),
                                  ),
                                );
                              })
                          : Center(
                              child: BigText(
                              text: "You have no order history",
                            )),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
