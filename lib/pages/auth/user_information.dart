import 'dart:io';
import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:trilix/model/user_model.dart';
import 'package:trilix/pages/home/home_sceen.dart';
import 'package:trilix/providers/auth_provider.dart';

import 'package:trilix/utils/dimensions.dart';
import 'package:trilix/utils/error_show.dart';
import 'package:trilix/utils/widgets/big_text.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  File? image;
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();
  final List<String> genderItems = [
    'Male',
    'Female',
  ];
  String? genderController;

  @override
  void dispose() {
    super.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    bioController.dispose();
  }

  bool isKeyboard = false;
  //random number

  int random = Random().nextInt(6) + 1;

  //for selecting Image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            isKeyboard = false;
          });
        },
        child: Scaffold(
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(
                      left: Dimentions.height20, right: Dimentions.height20),
                  child: Column(children: [
                    isKeyboard
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: image == null
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          top: Dimentions.height30),
                                      height: Dimentions.height100,
                                      width: Dimentions.height100,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/profile$random.png"),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(
                                            Dimentions.height100),
                                      ),
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(
                                          top: Dimentions.height30),
                                      child: CircleAvatar(
                                        backgroundImage: FileImage(image!),
                                        radius: Dimentions.height50,
                                      ),
                                    ),
                            ),
                          ),
                    SizedBox(
                      height: Dimentions.height45,
                    ),
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
                    Container(
                      height: Dimentions.height50,
                      child: TextField(
                        onTap: () {
                          setState(() {
                            isKeyboard = true;
                          });
                        },
                        cursorColor: Colors.red,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "First Name",
                            labelStyle: TextStyle(
                                color: isKeyboard ? Colors.black : Colors.red),
                            focusColor: Colors.red,
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                                borderRadius:
                                    BorderRadius.circular(Dimentions.height15)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.red),
                                borderRadius: BorderRadius.circular(
                                    Dimentions.height15))),
                      ),
                    ),

                    SizedBox(
                      height: Dimentions.height20,
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
                        cursorColor: Colors.red,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Last Name",
                            labelStyle: TextStyle(
                                color: isKeyboard ? Colors.black : Colors.red),
                            focusColor: Colors.red,
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                                borderRadius:
                                    BorderRadius.circular(Dimentions.height15)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.red),
                                borderRadius: BorderRadius.circular(
                                    Dimentions.height15))),
                      ),
                    ),

                    SizedBox(
                      height: Dimentions.height20,
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
                        cursorColor: Colors.red,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                                color: isKeyboard ? Colors.black : Colors.red),
                            focusColor: Colors.red,
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                                borderRadius:
                                    BorderRadius.circular(Dimentions.height15)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.red),
                                borderRadius: BorderRadius.circular(
                                    Dimentions.height15))),
                      ),
                    ),
                    SizedBox(
                      height: Dimentions.height20,
                    ),
                    //Gender
                    Container(
                      height: Dimentions.height50,
                      child: DropdownButtonFormField2(
                        decoration: InputDecoration(
                          //Add isDense true and zero Padding.
                          //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        isExpanded: true,
                        hint: const Text(
                          'Select Your Gender',
                          style: TextStyle(fontSize: 14),
                        ),
                        items: genderItems
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select gender.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          genderController = value.toString();
                          setState(() {
                            isKeyboard = false;
                            if (genderController == "Male") {
                              random = Random().nextInt(3) + 4;
                            } else if (genderController == "Female") {
                              random = Random().nextInt(3) + 1;
                            }
                          });
                        },
                        onSaved: (value) {
                          genderController = value.toString();
                        },
                        buttonStyleData: const ButtonStyleData(
                          height: 60,
                          padding: EdgeInsets.only(left: 20, right: 10),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                          iconSize: 30,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: Dimentions.height45,
                    ),
                    //Button
                    GestureDetector(
                      onTap: () {
                        storeData();
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: Dimentions.height20,
                            right: Dimentions.height20),
                        height: Dimentions.height50,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 25.0,
                                  color: Colors.red.withOpacity(0.8)),
                            ],
                            color: Colors.red,
                            borderRadius:
                                BorderRadius.circular(Dimentions.height30)),
                        child: Center(
                            child: BigText(
                          text: "TAKE ME HOME",
                          color: Colors.white,
                        )),
                      ),
                    ),
                  ]),
                ),
        ),
      ),
    );
  }

  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
      lastName: lastnameController.text.trim(),
      firstName: firstnameController.text.trim(),
      phoneNumber: "",
      email: emailController.text.trim(),
      profilePic: random,
      uid: "",
      createdAt: "",
    );

    ap.saveUserDataToFirebase(
        context: context,
        userModel: userModel,
        profilePic: random,
        onSuccess: () {
          ap.saveUserDataToSP().then(
                (value) => ap.setSignIn().then(
                      (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                          (route) => false),
                    ),
              );
        });
  }
}
