import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:provider/provider.dart';
import 'package:trilix/pages/auth/otp_page.dart';
import 'package:trilix/pages/home/home_sceen.dart';
import 'package:trilix/pages/home/home_travel_page.dart';
import 'package:trilix/providers/auth_provider.dart';
import 'package:trilix/utils/colors.dart';
import 'package:trilix/utils/dimensions.dart';
import 'package:trilix/utils/error_show.dart';
import 'package:trilix/utils/widgets/big_text.dart';
import 'package:trilix/utils/widgets/small_text.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
  SHOW_INFO_FORM_STATE,
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextEditingController phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? otpCode;
  String? verificationId;
  bool isLoading = false;
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
  }

  bool isKeyboard = false;
  //random number

  int random = Random().nextInt(6) + 1;

  //for selecting Image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  var currentState = MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  getMobileFormWidget(context) {
    return Column(children: [
      SizedBox(
        height: Dimentions.height250,
      ),
      Align(
        alignment: Alignment.center,
        child: Container(
          height: Dimentions.height45,
          width: Dimentions.height150,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/logo_text.png",
                  ),
                  fit: BoxFit.cover)),
        ),
      ),
      SizedBox(
        height: Dimentions.height45,
      ),
      SmallText(
        text: "Enter mobile number and login",
        color: Colors.black,
        size: Dimentions.fontSize16,
      ),
      SizedBox(
        height: Dimentions.height30,
      ),
      Container(
        margin: EdgeInsets.only(
            left: Dimentions.height20, right: Dimentions.height20),
        padding: EdgeInsets.only(
            left: Dimentions.height20, right: Dimentions.height20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimentions.height10),
            boxShadow: [
              BoxShadow(blurRadius: 25.0, color: Colors.black26),
            ],
            color: Colors.white),
        child: TextField(
          controller: phoneController,
          inputFormatters: [LengthLimitingTextInputFormatter(10)],
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Phone Number",
              prefixText: "+91  "),
          cursorColor: Colors.black26,
          keyboardType: TextInputType.number,
        ),
      ),
      SizedBox(
        height: Dimentions.height45,
      ),
      GestureDetector(
        onTap: () async {
          setState(() {
            isLoading = true;
          });
          await _auth.verifyPhoneNumber(
            phoneNumber: "+91${phoneController.text}",
            verificationCompleted: (PhoneAuthCredential) async {
              setState(() {
                isLoading = false;
              });
            },
            verificationFailed: (verificationFailed) async {
              setState(() {
                isLoading = false;
              });
              showSnackBar(context, verificationFailed.message.toString());
            },
            codeSent: (verificationId, resendingToken) async {
              setState(() {
                isLoading = false;
                currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                this.verificationId = verificationId;
              });
            },
            codeAutoRetrievalTimeout: (verificationId) async {},
          );
        },
        child: Container(
          margin: EdgeInsets.only(
              left: Dimentions.height20, right: Dimentions.height20),
          height: Dimentions.height50,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 25.0,
                    color: AppColors.bottomBarActiveColor.withOpacity(0.8)),
              ],
              color: AppColors.bottomBarActiveColor,
              borderRadius: BorderRadius.circular(Dimentions.height30)),
          child: Center(
              child: BigText(
            text: "NEXT",
            color: Colors.white,
          )),
        ),
      )
    ]);
  }

  getOTPFormWidget(context) {
    return Column(
      children: [
        SizedBox(
          height: Dimentions.height250,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: Dimentions.height45,
            width: Dimentions.height150,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/images/logo_text.png",
                    ),
                    fit: BoxFit.cover)),
          ),
        ),
        SizedBox(
          height: Dimentions.height45,
        ),
        SmallText(
          text: "Enter the verification code sent at",
          color: Colors.black,
          size: Dimentions.fontSize16,
        ),
        SizedBox(
          height: Dimentions.height10,
        ),
        SmallText(
          text: "+91 ${phoneController.text}",
          color: Colors.black,
          size: Dimentions.fontSize16,
        ),
        SizedBox(
          height: Dimentions.height30,
        ),
        Container(
          child: OtpTextField(
            margin: EdgeInsets.only(right: 7, left: 7),
            cursorColor: Colors.black,
            borderColor: AppColors.bottomBarActiveColor,
            focusedBorderColor: AppColors.bottomBarActiveColor,
            numberOfFields: 6,
            fillColor: Colors.black.withOpacity(0.1),
            filled: true,
            onSubmit: (code) {
              setState(() {
                otpCode = code;
              });
            },
          ),
        ),
        SizedBox(
          height: Dimentions.height45,
        ),
        GestureDetector(
          onTap: () async {
            if (otpCode != null) {
              PhoneAuthCredential phoneAuthCredential =
                  PhoneAuthProvider.credential(
                      verificationId: verificationId!, smsCode: otpCode!);

              signInWithPhoneAuthCredential(phoneAuthCredential);
            } else {
              showSnackBar(context, "Enter 6-Digit code");
            }
          },
          child: Container(
            margin: EdgeInsets.only(
                left: Dimentions.height20, right: Dimentions.height20),
            height: Dimentions.height50,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 25.0,
                      color: AppColors.bottomBarActiveColor.withOpacity(0.8)),
                ],
                color: AppColors.bottomBarActiveColor,
                borderRadius: BorderRadius.circular(Dimentions.height30)),
            child: Center(
                child: BigText(
              text: "LOGIN",
              color: Colors.white,
            )),
          ),
        )
      ],
    );
  }

  getInfoFormWidget(context) {
    return Container(
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
                          margin: EdgeInsets.only(top: Dimentions.height30),
                          height: Dimentions.height100,
                          width: Dimentions.height100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/profile$random.png"),
                                fit: BoxFit.cover),
                            borderRadius:
                                BorderRadius.circular(Dimentions.height100),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(top: Dimentions.height30),
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
                fontSize: Dimentions.height20, fontWeight: FontWeight.w700),
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
            controller: firstnameController,
            cursorColor: Colors.red,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: "First Name",
                labelStyle:
                    TextStyle(color: isKeyboard ? Colors.black : Colors.red),
                focusColor: Colors.red,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(Dimentions.height15)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.red),
                    borderRadius: BorderRadius.circular(Dimentions.height15))),
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
            controller: lastnameController,
            cursorColor: Colors.red,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: "Last Name",
                labelStyle:
                    TextStyle(color: isKeyboard ? Colors.black : Colors.red),
                focusColor: Colors.red,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(Dimentions.height15)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.red),
                    borderRadius: BorderRadius.circular(Dimentions.height15))),
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
            controller: emailController,
            decoration: InputDecoration(
                labelText: "Email",
                labelStyle:
                    TextStyle(color: isKeyboard ? Colors.black : Colors.red),
                focusColor: Colors.red,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(Dimentions.height15)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.red),
                    borderRadius: BorderRadius.circular(Dimentions.height15))),
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
          onTap: () async {
            //Upload here
            setState(() {
              isLoading = true;
            });
            try {
              List<bool> favList = [false, false, false, false, false, false];
              Map<String, dynamic> fav = {
                'favList': favList,
              };

              await FirebaseFirestore.instance
                  .collection("fav")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .set(fav);
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .set({
                "firstName": firstnameController.text,
                "lastName": lastnameController.text,
                "gender": genderController.toString(),
                "email": emailController.text,
                "phone": phoneController.text,
                "profileNo": random.toString(),
                "places": 0,
              });
              setState(() {
                isLoading = false;
              });
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            } on Exception catch (e) {
              setState(() {
                isLoading = false;
              });
              showSnackBar(context, e.toString());
            }
          },
          child: Container(
            margin: EdgeInsets.only(
                left: Dimentions.height20, right: Dimentions.height20),
            height: Dimentions.height50,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 25.0, color: Colors.red.withOpacity(0.8)),
                ],
                color: Colors.red,
                borderRadius: BorderRadius.circular(Dimentions.height30)),
            child: Center(
                child: BigText(
              text: "TAKE ME HOME",
              color: Colors.white,
            )),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(color: Colors.red),
              )
            : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                ? getMobileFormWidget(context)
                : currentState == MobileVerificationState.SHOW_OTP_FORM_STATE
                    ? getOTPFormWidget(context)
                    : getInfoFormWidget(context));
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      isLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        if (snapshot.exists) {
          setState(() {
            isLoading = false;
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          });
        } else {
          setState(() {
            isLoading = false;
            currentState = MobileVerificationState.SHOW_INFO_FORM_STATE;
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, e.message.toString());
    }
  }
}
