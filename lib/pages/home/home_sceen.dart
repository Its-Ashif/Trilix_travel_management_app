import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:trilix/pages/auth/login_page.dart';
import 'package:trilix/pages/bookings/booking_info.dart';
import 'package:trilix/pages/home/bookings_detail.dart';
import 'package:trilix/pages/home/bookmark_detail.dart';
import 'package:trilix/pages/home/home_detail.dart';
import 'package:trilix/pages/home/profile_detial.dart';
import 'package:trilix/utils/colors.dart';
import 'package:trilix/utils/dimensions.dart';
import 'package:trilix/utils/widgets/big_text.dart';

class HomeScreen extends StatefulWidget {
  var bottomNavBarCount;
  HomeScreen({super.key, this.bottomNavBarCount = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  List _bottomBarList = [
    HomeDetail(),
    BookmarkDetail(),
    BookingsDetail(),
    ProfileDetail(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9f9f9),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
            left: Dimentions.height20,
            right: Dimentions.height20,
            top: Dimentions.height10,
            bottom: Dimentions.height10),
        child: SalomonBottomBar(
          currentIndex: widget.bottomNavBarCount,
          onTap: (i) {
            setState(() {
              widget.bottomNavBarCount = i;
            });
          },
          items: [
            SalomonBottomBarItem(
                icon: const Icon(FluentIcons.home_20_filled),
                title: const Text("Home"),
                selectedColor: AppColors.bottomBarActiveColor,
                unselectedColor: AppColors.bottomBarInActiveColor),
            SalomonBottomBarItem(
                icon: const Icon(FluentIcons.bookmark_20_filled),
                title: Text("Favorite"),
                selectedColor: AppColors.bottomBarActiveColor,
                unselectedColor: AppColors.bottomBarInActiveColor),
            SalomonBottomBarItem(
                icon: Icon(FluentIcons.receipt_20_filled),
                title: Text("Bookings"),
                selectedColor: AppColors.bottomBarActiveColor,
                unselectedColor: AppColors.bottomBarInActiveColor),
            SalomonBottomBarItem(
                icon: Icon(FluentIcons.person_circle_20_filled),
                title: Text("Profile"),
                selectedColor: AppColors.bottomBarActiveColor,
                unselectedColor: AppColors.bottomBarInActiveColor)
          ],
        ),
      ),
      body: _bottomBarList[widget.bottomNavBarCount],
    );
  }
}
