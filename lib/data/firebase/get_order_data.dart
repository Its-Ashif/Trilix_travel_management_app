import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetOrderData {
  final _auth = FirebaseAuth.instance;
  Future<Map<String, dynamic>> getOrderData() async {
    CollectionReference users =
        await FirebaseFirestore.instance.collection('orders');
    final snapshot = await users.doc(_auth.currentUser?.uid).get();
    final data = snapshot.data() as Map<String, dynamic>;
    return data;
  }
}
