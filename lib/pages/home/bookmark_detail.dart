import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:trilix/data/place_data.dart';
import 'package:trilix/pages/home/travel_detail.dart';
import 'package:trilix/utils/colors.dart';
import 'package:trilix/utils/dimensions.dart';
import 'package:trilix/utils/widgets/big_text.dart';
import 'package:trilix/utils/widgets/small_text.dart';

class BookmarkDetail extends StatefulWidget {
  const BookmarkDetail({super.key});

  @override
  State<BookmarkDetail> createState() => _BookmarkDetailState();
}

bool isLoading = true;
Map<String, dynamic> fav_data = {};
int fav_item_count = 0;

class _BookmarkDetailState extends State<BookmarkDetail> {
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
          for (int i = 0; i < 6; i++) {
            if (fav_data['favList'][i] == true) {
              fav_item_count += 1;
            }
          }
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

    return SafeArea(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: AppColors.bottomBarActiveColor),
            )
          : Column(
              children: [
                SizedBox(
                  height: Dimentions.height30,
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: Dimentions.height30, right: Dimentions.height30),
                  alignment: Alignment.centerLeft,
                  child: BigText(
                    text: "Favorites.",
                    size: Dimentions.height25,
                  ),
                ),
                SizedBox(
                  height: fav_item_count == 0
                      ? Dimentions.height150
                      : Dimentions.height20,
                ),
                fav_item_count == 0
                    ? Center(
                        child: BigText(text: "You have no bookmarks"),
                      )
                    : Container(
                        height: Dimentions.height350 +
                            Dimentions.height300 +
                            Dimentions.height30 -
                            Dimentions.height45,
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: 6,
                            itemBuilder: (BuildContext context, int index) {
                              return fav_data['favList'][index]
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => TravelDetails(
                                                    index: index,
                                                    name: PlaceData
                                                        .places[index]['name']
                                                        .toString(),
                                                    place: PlaceData.places[index]
                                                            ['location']
                                                        .toString(),
                                                    imageURL: PlaceData.places[index]
                                                            ['imageURL']
                                                        .toString(),
                                                    distance: PlaceData.places[index]
                                                            ['distance']
                                                        .toString(),
                                                    rating: PlaceData
                                                        .places[index]['rating']
                                                        .toString(),
                                                    price: PlaceData.places[index]['price'].toInt(),
                                                    description: PlaceData.places[index]['description'].toString())));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: Dimentions.height30,
                                            right: Dimentions.height30,
                                            bottom: Dimentions.height20),
                                        padding:
                                            EdgeInsets.all(Dimentions.height15),
                                        height: Dimentions.height150,
                                        width: double.maxFinite,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
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
                                                        PlaceData.places[index]
                                                            ['imageURL']),
                                                    fit: BoxFit.cover),
                                                borderRadius:
                                                    BorderRadius.circular(
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
                                                text: PlaceData.places[index]
                                                    ['name'],
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
                                                    FluentIcons
                                                        .location_20_filled,
                                                    size: Dimentions.height20,
                                                    color: Colors.red,
                                                  ),
                                                  SizedBox(
                                                    width: Dimentions.height5,
                                                  ),
                                                  SmallText(
                                                      text: PlaceData
                                                              .places[index]
                                                          ['name'])
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
                                                    FluentIcons.star_24_filled,
                                                    color: Color(0xffffbd09),
                                                    size: Dimentions.height20,
                                                  ),
                                                  SizedBox(
                                                    width: Dimentions.height5,
                                                  ),
                                                  SmallText(
                                                      text: PlaceData
                                                              .places[index]
                                                          ['rating'])
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
                                                    color: AppColors
                                                        .bottomBarActiveColor,
                                                  ),
                                                  SizedBox(
                                                    width: Dimentions.height5,
                                                  ),
                                                  SmallText(
                                                      text: PlaceData
                                                          .places[index]
                                                              ['price']
                                                          .toString())
                                                ],
                                              ),
                                            ],
                                          )
                                        ]),
                                      ),
                                    )
                                  : Container();
                            }),
                      )
              ],
            ),
    );
  }
}
