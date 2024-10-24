import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthServices {
  Future<bool> signup(String email, String password) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    await users.add({
      'username': 'mse',
      'password': 'mse',
      'count': 0,
    });

    return true;
  }

  void readData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Retrieve all documents in the 'users' collection
    QuerySnapshot querySnapshot = await users.get();
    for (var doc in querySnapshot.docs) {
      print(
          'username: ${doc['username']}, password: ${doc['password']}, count: ${doc['count']}');
    }

    // Retrieve a specific document
    DocumentSnapshot documentSnapshot = await users.doc('documentId').get();
    print(documentSnapshot);
  }
}
