import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:trilix/pages/auth/login_page.dart';
import 'package:trilix/pages/auth/user_information.dart';
import 'package:trilix/pages/bookings/booking_info.dart';
import 'package:trilix/pages/home/current_user.dart';
import 'package:trilix/pages/home/home_sceen.dart';
import 'package:trilix/pages/home/home_travel_page.dart';
import 'package:trilix/pages/home/travel_detail.dart';
import 'package:trilix/pages/home/travel_page_body.dart';
import 'package:trilix/pages/travel/popular_travel_detail.dart';
import 'package:trilix/providers/auth_provider.dart';
import 'helper/dependancies.dart' as dep;
import 'pages/auth/otp_page.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dep.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: ResponsiveSizer(builder: (context, orientation, deviceType) {
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Trilix',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
            ),
            home: CheckUser() //MainTravelPage(),
            );
      }),
    );
  }
}
