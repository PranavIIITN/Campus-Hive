import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../models/user.dart'; // Your custom User model

class AuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  Future<User> createUser(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebaseUser(userCredential.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw e.message ?? "An error occurred during sign up.";
    }
  }

  Future<User> signInUser(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebaseUser(userCredential.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw e.message ?? "An error occurred during sign in.";
    }
  }

  User _userFromFirebaseUser(fb.User firebaseUser) {
    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
    );
  }
}
