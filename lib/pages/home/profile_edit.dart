import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:trilix/pages/home/home_sceen.dart';
import 'package:trilix/pages/home/profile_detial.dart';

import 'package:trilix/utils/colors.dart';
import 'package:trilix/utils/dimensions.dart';
import 'package:trilix/utils/error_show.dart';
import 'package:trilix/utils/widgets/big_text.dart';

class ProfileEdit extends StatefulWidget {
  Map<String, dynamic> user_data_edit;
  ProfileEdit({super.key, required this.user_data_edit});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

final _auth = FirebaseAuth.instance;
bool isLoading = false;
bool isKeyboard = false;

class _ProfileEditState extends State<ProfileEdit> {
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
            top: Dimentions.height15,
            bottom: Dimentions.height30,
            left: Dimentions.height40,
            right: Dimentions.height40),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            height: Dimentions.height50,
            width: Dimentions.height120,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Dimentions.height20)),
                    primary: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: BigText(
                  text: "Discard",
                  color: Colors.white,
                )),
          ),
          Container(
            height: Dimentions.height50,
            width: Dimentions.height100,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Dimentions.height20)),
                    primary: AppColors.bottomBarActiveColor),
                onPressed: () async {
                  String text1 = firstnameController.text;
                  String text2 = lastnameController.text;
                  String text3 = emailController.text;
                  setState(() {
                    isLoading = true;
                  });
                  if (text1 != '') {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(_auth.currentUser!.uid)
                        .update({"firstName": text1});
                  }
                  if (text2 != '') {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(_auth.currentUser!.uid)
                        .update({"lastName": text2});
                  }
                  if (text3 != '') {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(_auth.currentUser!.uid)
                        .update({"email": text3});
                  }
                  if (text1 == '' && text2 == '' && text3 == '') {
                    setState(() {
                      isLoading = false;
                    });
                    showSnackBar(context, "Edit your data first!");
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(
                                  bottomNavBarCount: 3,
                                )),
                        (route) => false);
                  }
                },
                child: BigText(
                  text: "Save",
                  color: Colors.white,
                )),
          )
        ]),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.bottomBarActiveColor,
              ),
            )
          : SafeArea(
              child: Container(
                margin: EdgeInsets.all(Dimentions.height30),
                child: Column(children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Your Information",
                      style: TextStyle(
                          fontSize: Dimentions.height20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: Dimentions.height30,
                  ),
                  //FirstName
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "First Name",
                      style: TextStyle(
                          fontSize: Dimentions.height20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: Dimentions.height10,
                  ),
                  Container(
                    height: Dimentions.height50,
                    child: TextField(
                      onTap: () {
                        setState(() {
                          isKeyboard = true;
                        });
                      },
                      controller: firstnameController,
                      cursorColor: AppColors.bottomBarActiveColor,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText:
                              widget.user_data_edit['firstName'].toString(),
                          labelStyle: TextStyle(
                              color: isKeyboard
                                  ? Colors.black
                                  : AppColors.bottomBarActiveColor),
                          focusColor: AppColors.bottomBarActiveColor,
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                              borderRadius:
                                  BorderRadius.circular(Dimentions.height15)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: AppColors.bottomBarActiveColor),
                              borderRadius:
                                  BorderRadius.circular(Dimentions.height15))),
                    ),
                  ),

                  SizedBox(
                    height: Dimentions.height20,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Last Name",
                      style: TextStyle(
                          fontSize: Dimentions.height20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: Dimentions.height10,
                  ),

                  //Last Name
                  Container(
                    height: Dimentions.height50,
                    child: TextField(
                      onTap: () {
                        setState(() {
                          isKeyboard = true;
                        });
                      },
                      controller: lastnameController,
                      cursorColor: AppColors.bottomBarActiveColor,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText:
                              widget.user_data_edit['lastName'].toString(),
                          labelStyle: TextStyle(
                              color: isKeyboard
                                  ? Colors.black
                                  : AppColors.bottomBarActiveColor),
                          focusColor: AppColors.bottomBarActiveColor,
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                              borderRadius:
                                  BorderRadius.circular(Dimentions.height15)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: AppColors.bottomBarActiveColor),
                              borderRadius:
                                  BorderRadius.circular(Dimentions.height15))),
                    ),
                  ),

                  SizedBox(
                    height: Dimentions.height20,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Email Address",
                      style: TextStyle(
                          fontSize: Dimentions.height20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: Dimentions.height10,
                  ),
                  //Email
                  Container(
                    height: Dimentions.height50,
                    child: TextField(
                      onTap: () {
                        setState(() {
                          isKeyboard = true;
                        });
                      },
                      cursorColor: AppColors.bottomBarActiveColor,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: widget.user_data_edit['email'].toString(),
                          labelStyle: TextStyle(
                              color: isKeyboard
                                  ? Colors.black
                                  : AppColors.bottomBarActiveColor),
                          focusColor: AppColors.bottomBarActiveColor,
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                              borderRadius:
                                  BorderRadius.circular(Dimentions.height15)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: AppColors.bottomBarActiveColor),
                              borderRadius:
                                  BorderRadius.circular(Dimentions.height15))),
                    ),
                  ),
                  SizedBox(
                    height: Dimentions.height20,
                  ),
                ]),
              ),
            ),
    );
  }
}
