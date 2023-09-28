import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:trilix/pages/auth/login_page.dart';
import 'package:trilix/pages/home/home_sceen.dart';
import 'package:trilix/utils/colors.dart';
import 'package:trilix/utils/error_show.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    Future<void> checkUser() async {
      CollectionReference user = FirebaseFirestore.instance.collection('users');
      final snapshot = await user.doc(_auth.currentUser?.uid).get();
      if (snapshot.exists) {
        if (!mounted) return;

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        if (!mounted) return;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    }

    checkUser();

    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(color: AppColors.bottomBarActiveColor),
    ));
  }
}
