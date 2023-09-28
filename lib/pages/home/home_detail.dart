import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:trilix/data/firebase/get_data.dart';
import 'package:trilix/data/place_data.dart';
import 'package:trilix/pages/home/bookings_detail.dart';
import 'package:trilix/pages/home/home_sceen.dart';
import 'package:trilix/pages/home/profile_detial.dart';
import 'package:trilix/pages/home/travel_detail.dart';
import 'package:trilix/utils/colors.dart';
import 'package:trilix/utils/dimensions.dart';
import 'package:trilix/utils/widgets/big_text.dart';
import 'package:trilix/utils/widgets/small_text.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeDetail extends StatefulWidget {
  const HomeDetail({super.key});

  @override
  State<HomeDetail> createState() => _HomeDetailState();
}

final _auth = FirebaseAuth.instance;
Map<String, dynamic> user_data = {};
Map<String, dynamic> fav_data = {};
bool isLoading = true;

Map<String, dynamic> placeInfo = {
  'Delhi': 0,
  'Rajasthan': 1,
  'Mumbai': 2,
  'Chennai': 3,
  'Guwahati': 4,
  'Patna': 5,
};

Map<int, Map<String, dynamic>> tour = {
  0: {
    'name': 'South India Tour',
    'place': 'Chennai',
    'imageURL': 'assets/images/chennai.jpg'
  },
  1: {
    'name': 'North India Tour',
    'place': 'Delhi',
    'imageURL': 'assets/images/delhi.PNG'
  },
  2: {
    'name': 'Indian Desert Tour',
    'place': 'Rajasthan',
    'imageURL': 'assets/images/rajasthan.jpg'
  },
};

class _HomeDetailState extends State<HomeDetail> {
  @override
  Widget build(BuildContext context) {
    Future<void> getUserData() async {
      Map<String, dynamic> data = await DatabaseService().getUser();
      if (!mounted) {
        return;
      }
      setState(() {
        user_data = data;
      });
    }

    Future<void> getFav() async {
      CollectionReference fav =
          await FirebaseFirestore.instance.collection('fav');
      final snapshot = await fav.doc(_auth.currentUser?.uid).get();
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

    getUserData();
    getFav();

    return isLoading
        ? Center(
            child: CircularProgressIndicator(
                color: AppColors.bottomBarActiveColor),
          )
        : SafeArea(
            child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: Dimentions.height20),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: Dimentions.height30,
                      right: Dimentions.height30,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            height: Dimentions.height50,
                            width: Dimentions.height50,
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/images/trilix_logo.svg',
                                color: AppColors.bottomBarActiveColor,
                              ),
                            )),
                        InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                          bottomNavBarCount: 3,
                                        )),
                                (route) => false);
                          },
                          child: Container(
                            height: Dimentions.height50,
                            width: Dimentions.height50,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimentions.height30),
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/profile${user_data['profileNo'].toString()}.png"))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dimentions.height45,
                  ),
                  GestureDetector(
                    onTap: () {
                      showSearch(
                          context: context, delegate: MySearchDelegate());
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        left: Dimentions.height30,
                        right: Dimentions.height30,
                      ),
                      padding: EdgeInsets.all(Dimentions.height7),
                      height: Dimentions.height50,
                      decoration: BoxDecoration(
                          color: Color(0xfff1f5fe),
                          borderRadius:
                              BorderRadius.circular(Dimentions.height30)),
                      child: Row(children: [
                        Container(
                          padding: EdgeInsets.all(Dimentions.height5),
                          height: Dimentions.height45,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimentions.height30),
                              color: AppColors.bottomBarInActiveColor),
                          child: Icon(
                            FluentIcons.search_12_regular,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: Dimentions.height15,
                        ),
                        Text(
                          "Search",
                          style: TextStyle(
                              fontSize: Dimentions.fontSize16,
                              fontWeight: FontWeight.bold),
                        )
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: Dimentions.height45,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                      left: Dimentions.height30,
                      right: Dimentions.height30,
                    ),
                    child: BigText(
                      text: "Featured.",
                      size: Dimentions.height25,
                    ),
                  ),
                  SizedBox(
                    height: Dimentions.height20,
                  ),
                  Container(
                    height: Dimentions.height100,
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
                    ),
                    child: Swiper(
                      itemCount: 3,
                      viewportFraction: 0.8,
                      scale: 0.9,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TravelDetails(
                                        index: placeInfo[
                                            tour[index]!['place'].toString()],
                                        name: PlaceData.places[placeInfo[tour[index]!['place']]]['name']
                                            .toString(),
                                        place: PlaceData
                                            .places[placeInfo[tour[index]!['place']]]
                                                ['location']
                                            .toString(),
                                        imageURL: PlaceData
                                            .places[placeInfo[tour[index]!['place']]]
                                                ['imageURL']
                                            .toString(),
                                        distance: PlaceData
                                            .places[placeInfo[tour[index]!['place']]]
                                                ['distance']
                                            .toString(),
                                        rating: PlaceData.places[placeInfo[tour[index]!['place']]]['rating'].toString(),
                                        price: PlaceData.places[placeInfo[tour[index]!['place']]]['price'].toInt(),
                                        description: PlaceData.places[placeInfo[tour[index]!['place']]]['description'].toString())));
                          },
                          child: Container(
                            padding: EdgeInsets.all(Dimentions.height20),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimentions.height15),
                                color: Colors.white),
                            child: Row(
                              children: [
                                Container(
                                  height: Dimentions.height70,
                                  width: Dimentions.height70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimentions.height15),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              tour[index]!['imageURL']
                                                  .toString()),
                                          fit: BoxFit.cover)),
                                ),
                                SizedBox(
                                  width: Dimentions.height15,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BigText(
                                      text: tour[index]!['name'].toString(),
                                      size: Dimentions.height20,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: SmallText(
                                        text: tour[index]!['place'].toString(),
                                        size: Dimentions.height15,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: Dimentions.height45,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                      left: Dimentions.height30,
                      right: Dimentions.height30,
                    ),
                    child: BigText(
                      text: "Recommended.",
                      size: Dimentions.height25,
                    ),
                  ),
                  SizedBox(
                    height: Dimentions.height20,
                  ),
                  Container(
                    height: Dimentions.height450 + Dimentions.height220,
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      children: List.generate(6, (index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TravelDetails(
                                        index: index,
                                        name: PlaceData.places[index]['name']
                                            .toString(),
                                        place: PlaceData.places[index]['location']
                                            .toString(),
                                        imageURL: PlaceData.places[index]
                                                ['imageURL']
                                            .toString(),
                                        distance: PlaceData.places[index]
                                                ['distance']
                                            .toString(),
                                        rating: PlaceData.places[index]['rating']
                                            .toString(),
                                        price: PlaceData.places[index]['price']
                                            .toInt(),
                                        description: PlaceData.places[index]
                                                ['description']
                                            .toString())));
                          },
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.all(Dimentions.height10),
                              height: Dimentions.height200,
                              width: Dimentions.height200,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimentions.height15),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 20.0,
                                    spreadRadius: 1,
                                    offset: Offset(0, 20),
                                  )
                                ],
                              ),
                              child: Column(children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: Dimentions.height100,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimentions.height15),
                                          image: DecorationImage(
                                              image: AssetImage(PlaceData
                                                  .places[index]['imageURL']),
                                              fit: BoxFit.cover)),
                                    ),
                                    Positioned(
                                      right: 10,
                                      top: 10,
                                      child: Container(
                                        height: Dimentions.height30,
                                        width: Dimentions.height50,
                                        child: Center(
                                          child: BigText(
                                            text: PlaceData.places[index]
                                                    ['price']
                                                .toString(),
                                            size: Dimentions.fontSize16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                Dimentions.height10),
                                            color:
                                                AppColors.bottomBarActiveColor),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: Dimentions.height10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BigText(
                                          text: PlaceData.places[index]['name'],
                                          size: Dimentions.height13,
                                        ),
                                        SmallText(
                                          text: PlaceData.places[index]['name'],
                                          size: Dimentions.height13,
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: Dimentions.height30,
                                      width: Dimentions.height30,
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (fav_data['favList'][index] ==
                                              false) {
                                            fav_data['favList'][index] = true;
                                            await FirebaseFirestore.instance
                                                .collection('fav')
                                                .doc(_auth.currentUser!.uid)
                                                .update({
                                              'favList': fav_data['favList']
                                            });
                                          } else {
                                            fav_data['favList'][index] = false;
                                            await FirebaseFirestore.instance
                                                .collection('fav')
                                                .doc(_auth.currentUser!.uid)
                                                .update({
                                              'favList': fav_data['favList']
                                            });
                                          }
                                        },
                                        child: Icon(
                                          FluentIcons.bookmark_16_filled,
                                          color: fav_data['favList'][index] ==
                                                  false
                                              ? Colors.grey
                                              : AppColors.bottomBarActiveColor,
                                          size: Dimentions.height15,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              blurRadius: 20.0,
                                              spreadRadius: 1,
                                              offset: Offset(0, 20),
                                            )
                                          ],
                                          borderRadius: BorderRadius.circular(
                                              Dimentions.height30),
                                          color: Colors.white),
                                    )
                                  ],
                                )
                              ]),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ));
  }
}

class MySearchDelegate extends SearchDelegate {
  List<String> searchResults = [
    'Delhi',
    'Rajasthan',
    'Mumbai',
    'Chennai',
    'Guwahati',
    'Patna'
  ];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back));

  @override
  List<Widget>? buildActions(BuildContext context) {
    IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.clear));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];

          return ListTile(
            title: Text(suggestion),
            onTap: () {
              query = suggestion;

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TravelDetails(
                          index: placeInfo[query],
                          name: PlaceData.places[placeInfo[query]]['name']
                              .toString(),
                          place: PlaceData.places[placeInfo[query]]['location']
                              .toString(),
                          imageURL: PlaceData.places[placeInfo[query]]
                                  ['imageURL']
                              .toString(),
                          distance: PlaceData.places[placeInfo[query]]
                                  ['distance']
                              .toString(),
                          rating: PlaceData.places[placeInfo[query]]['rating']
                              .toString(),
                          price: PlaceData.places[placeInfo[query]]['price']
                              .toInt(),
                          description: PlaceData.places[placeInfo[query]]
                                  ['description']
                              .toString())));
            },
          );
        });
  }
}
