import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenz/models/user_model.dart';
import 'package:expenz/services/auth/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference _usersCollection = _firestore.collection('users');

  Future<void> saveUserData(UserModel user) async {
    try {
      final userCredential = await AuthServices()
          .createUserWithEmailAndPassword(
            email: user.email,
            password: user.password,
          );

      final userId = userCredential.user?.uid;

      if (userId != null) {
        final userMap = user.toJson();
        userMap['userId'] = userId;
        userMap['uid'] = userId;
        userMap['email'] = user.email;
        userMap['name'] = user.name;

        await _usersCollection
            .doc(userId)
            .set(userMap, SetOptions(merge: true));
      }
    } catch (error) {
      print('Error saving user: $error');
      rethrow;
    }
  }

  static Future<UserCredential> loginUser(String email, String password) async {
    return AuthServices().signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<bool> checkUsername() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final snapshot = await _firestore.collection('users').doc(user.uid).get();
    final data = snapshot.data();
    if (data == null) return false;

    final username = data['name'];
    return username != null && username.toString().trim().isNotEmpty;
  }

  static Future<Map<String, String>> getUserData() async {
    final user = _auth.currentUser;
    if (user == null) return {};

    final snapshot = await _firestore.collection('users').doc(user.uid).get();
    if (!snapshot.exists) return {};

    final data = snapshot.data() ?? {};
    return {
      'username': (data['name'] ?? '').toString(),
      'email': (data['email'] ?? user.email ?? '').toString(),
    };
  }

  Future<void> removeDetails() async {
    await _auth.signOut();
  }
}
