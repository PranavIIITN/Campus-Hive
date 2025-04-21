import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import 'user_service.dart';

class AuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

  Future<User> createUser(
    String email,
    String password,
    String name,
    String? year,
    String? rollNo,
    String? branch,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        final user = User(
          id: userCredential.user!.uid,
          email: email,
          name: name,
          year: year,
          rollNo: rollNo,
          branch: branch,
        );

        await _userService.createUser(user);
        return user;
      } else {
        throw "Failed to create user";
      }
    } on fb.FirebaseAuthException catch (e) {
      print('Exception during sign up: ${e.message}');
      throw e.message ?? "An error occurred during sign up";
    }
    print("Finished creating user");
  }

  Future<User> signInUser(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return await _userService.getUser(userCredential.user!.uid);
      } else {
        throw "Failed to sign in";
      }
    } on fb.FirebaseAuthException catch (e) {
      throw e.message ?? "An error occurred during sign in";
    }
    print("Finished signin user");
  }

  User _userFromFirebaseUser(fb.User firebaseUser) {
    return User(id: firebaseUser.uid, email: firebaseUser.email ?? '');
  }
}

