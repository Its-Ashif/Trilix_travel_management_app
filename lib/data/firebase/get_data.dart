import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final _auth = FirebaseAuth.instance;
  Future<Map<String, dynamic>> getUser() async {
    CollectionReference users =
        await FirebaseFirestore.instance.collection('users');
    final snapshot = await users.doc(_auth.currentUser?.uid).get();
    final data = snapshot.data() as Map<String, dynamic>;
    return data;
  }
}
