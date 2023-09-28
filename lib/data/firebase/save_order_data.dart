import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:trilix/utils/error_show.dart';

class SaveOrderData {
  String peopleCount;
  Map peopleInfo;
  String startdate;
  String enddate;
  Map placeDetails;
  String depurtureName;
  String depurtureCost;
  String returnName;
  String returnCost;
  Map hotel;
  SaveOrderData(
      {required this.peopleCount,
      required this.peopleInfo,
      required this.startdate,
      required this.placeDetails,
      required this.enddate,
      required this.depurtureName,
      required this.depurtureCost,
      required this.returnName,
      required this.returnCost,
      required this.hotel});

  Future<bool> saveOrderData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("orders")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (snapshot.exists) {
      try {
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'orderHistory': FieldValue.arrayUnion([
            {
              'peopleCount': peopleCount,
              'peopleInfo': peopleInfo,
              'startDate': startdate,
              'placeDetails': placeDetails,
              'endDate': enddate,
              'depurtureName': depurtureName,
              'depurtureCost': depurtureCost,
              'returnName': returnName,
              'returnCost': returnCost,
              'hotel': hotel,
            }
          ])
        });
        print('Success');
      } catch (e) {
        print(e.toString());
      }
      print("ORDER EXISTS");
    } else {
      try {
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'orderHistory': [
            {
              'peopleCount': peopleCount,
              'peopleInfo': peopleInfo,
              'placeDetails': placeDetails,
              'startDate': startdate,
              'endDate': enddate,
              'depurtureName': depurtureName,
              'depurtureCost': depurtureCost,
              'returnName': returnName,
              'returnCost': returnCost,
              'hotel': hotel,
            }
          ]
        });
        print('Success');
      } catch (e) {
        print(e.toString());
      }
    }

    return true;
  }
}
