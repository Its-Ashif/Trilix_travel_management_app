import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:trilix/data/place_data.dart';
import 'package:trilix/pages/bookings/booking_info.dart';

import 'package:trilix/utils/colors.dart';
import 'package:trilix/utils/dimensions.dart';
import 'package:trilix/utils/widgets/big_text.dart';
import 'package:trilix/utils/widgets/expandable_text.dart';

class TravelDetails extends StatefulWidget {
  final int index;
  final String name;
  final String place;
  final String imageURL;
  final String distance;
  final String rating;
  final int price;
  final String description;
  const TravelDetails({
    super.key,
    required this.index,
    required this.name,
    required this.place,
    required this.imageURL,
    required this.distance,
    required this.rating,
    required this.price,
    required this.description,
  });

  @override
  State<TravelDetails> createState() => _TravelDetailsState();
}

bool isLoading = true;
Map<String, dynamic> fav_data = {};

class _TravelDetailsState extends State<TravelDetails> {
  @override
  Widget build(BuildContext context) {
    Future<void> getFav() async {
      CollectionReference fav =
          await FirebaseFirestore.instance.collection('fav');
      final snapshot =
          await fav.doc(FirebaseAuth.instance.currentUser?.uid).get();
      if (snapshot.exists) {
        if (!mounted) {
          return;
        }
        setState(() {
          fav_data = snapshot.data() as Map<String, dynamic>;

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

    getFav();

    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: AppColors.bottomBarActiveColor),
            )
          : SafeArea(
              child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: Dimentions.height10,
                          right: Dimentions.height10,
                          top: Dimentions.height10),
                      height: Dimentions.height350 + Dimentions.height50,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              blurRadius: 20.0,
                              spreadRadius: 1,
                              offset: Offset(0, 20),
                            )
                          ],
                          borderRadius:
                              BorderRadius.circular(Dimentions.height20),
                          image: DecorationImage(
                              image: AssetImage(widget.imageURL),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: Dimentions.height30,
                          left: Dimentions.height30,
                          right: Dimentions.height30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: Dimentions.height50,
                              height: Dimentions.height50,
                              child: Center(
                                  child:
                                      Icon(FluentIcons.arrow_left_16_filled)),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimentions.height30),
                                  color: Colors.white),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (fav_data['favList'][widget.index] == false) {
                                fav_data['favList'][widget.index] = true;
                                await FirebaseFirestore.instance
                                    .collection('fav')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({'favList': fav_data['favList']});
                              } else {
                                fav_data['favList'][widget.index] = false;
                                await FirebaseFirestore.instance
                                    .collection('fav')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({'favList': fav_data['favList']});
                              }
                            },
                            child: Container(
                              width: Dimentions.height50,
                              height: Dimentions.height50,
                              child: Center(
                                  child: Icon(
                                FluentIcons.bookmark_16_filled,
                                color:
                                    fav_data['favList'][widget.index] == false
                                        ? Colors.grey
                                        : AppColors.bottomBarActiveColor,
                              )),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimentions.height30),
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: Dimentions.height30,
                      left: Dimentions.height40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BigText(
                            text: widget.name,
                            color: Colors.white,
                            size: Dimentions.height30,
                          ),
                          SizedBox(
                            height: Dimentions.height10,
                          ),
                          BigText(
                            text: '${widget.price}/person',
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: Dimentions.height30,
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: Dimentions.height70,
                          right: Dimentions.height70),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Icon(
                                FluentIcons.location_12_filled,
                                color: Colors.red,
                              ),
                              SizedBox(
                                height: Dimentions.height7,
                              ),
                              BigText(
                                text: widget.distance,
                                size: Dimentions.height17,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                FluentIcons.clock_16_filled,
                                color: Color(0xff09b3ff),
                              ),
                              SizedBox(
                                height: Dimentions.height7,
                              ),
                              BigText(
                                text: "3 Days",
                                size: Dimentions.height17,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                FluentIcons.star_24_filled,
                                color: Color(0xffffbd09),
                              ),
                              SizedBox(
                                height: Dimentions.height7,
                              ),
                              BigText(
                                text: widget.rating,
                                size: Dimentions.height17,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Dimentions.height30,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: Dimentions.height20),
                      alignment: Alignment.topLeft,
                      child: BigText(
                        text: "Description.",
                        size: Dimentions.height25,
                      ),
                    ),
                    SizedBox(
                      height: Dimentions.height20,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: Dimentions.height20,
                          right: Dimentions.height20),
                      height: Dimentions.height200 - Dimentions.height50,
                      child: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: ExpandableText(text: widget.description),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            )),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookingInfo(
                        placeName: widget.name,
                        location: widget.place,
                        imageURL: widget.imageURL,
                      )));
        },
        child: Container(
          height: Dimentions.height70,
          margin: EdgeInsets.all(Dimentions.height20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimentions.height20),
            color: AppColors.bottomBarActiveColor,
          ),
          child: Center(
            child: BigText(
              text: "Book Now",
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
