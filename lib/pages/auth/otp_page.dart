import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';
import 'package:trilix/pages/auth/user_information.dart';
import 'package:trilix/providers/auth_provider.dart';

import 'package:trilix/utils/dimensions.dart';
import 'package:trilix/utils/error_show.dart';
import 'package:trilix/utils/widgets/big_text.dart';
import 'package:trilix/utils/widgets/small_text.dart';

class OTP_Page extends StatefulWidget {
  final String verificationId;

  const OTP_Page({super.key, required this.verificationId});

  @override
  State<OTP_Page> createState() => _OTP_PageState();
}

class _OTP_PageState extends State<OTP_Page> {
  String? otpCode;
  @override
  Widget build(BuildContext context) {
    final isLoading = false;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              )
            : Column(
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
                    text: "+91 1234567890",
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
                      borderColor: Colors.red,
                      focusedBorderColor: Colors.red,
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
                    onTap: () {
                      if (otpCode != null) {
                      } else {
                        showSnackBar(context, "Enter 6-Digit code");
                      }
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
                        text: "LOGIN",
                        color: Colors.white,
                      )),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
