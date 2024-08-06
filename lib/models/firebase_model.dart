import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUtils {
  static final users = FirebaseFirestore.instance.collection('users');
  static final messages = FirebaseFirestore.instance.collection('messages');
}
