import '../models/user.dart'; // Assuming the User model is in models/user.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserService() {
    // You can perform any initialization here if needed.
  }

  Future<void> createUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.id).set({
        'email': user.email,
        'name': user.name,
        'year': user.year,
        'rollNo': user.rollNo,
        'branch': user.branch,
      });
      print("Creating user in Firestore: ${user.id}");
      print("User created successfully: ${user.id}");
    } catch (e) {
      print("Error creating user: $e");
      rethrow; // Re-throw the error to be handled by the caller.
    }
  }

  Future<User> getUser(String id) async {
    print("Fetching user with ID: $id");
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      if (doc.exists) {
        print("User document found for ID: $id");
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          return User(
            id: id,
            email: data['email'] as String?,
            name: data['name'] as String?,
            year: data['year'] as String?,
            rollNo: data['rollNo'] as String?,
            branch: data['branch'] as String?,
          );
        }
      }
      print("User service: User not found");
      throw 'User not found';
    } catch (e) {
      print("Error fetching user: $e");
      rethrow;
    }
  }

}
