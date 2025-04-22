import '../models/user.dart'; // Assuming the User model is in models/user.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

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
        'profileImageUrl': user.profileImageUrl,
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
          final user =  User(
              id: id,
              email: data['email'] as String?,
              name: data['name'] as String?,
              year: data['year'] as String?,
              rollNo: data['rollNo'] as String?,
              branch: data['branch'] as String?,
              profileImageUrl: data['profileImageUrl'] as String?,
          );
            print("User service: user fetched successfully");
            return user;
        }
      }
      print("User service: User not found");
      throw 'User not found';
    } catch (e) {
      print("Error fetching user: $e");
      throw 'Error fetching user: $e';
    }
  }

  Future<void> uploadProfilePicture(String userId, File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('profile_images/$userId.jpg');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() => {});
      final profilePictureUrl = await snapshot.ref.getDownloadURL();
      await _firestore.collection('users').doc(userId).update({
        'profileImageUrl': profilePictureUrl,
      });
    } catch (e) {
      print("Error uploading profile picture: $e");
      rethrow;
    }
  }

  Future<List<User>> getAllUsers() async {
    print("Fetching all users");
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return User(
          id: doc.id,
          email: data['email'] as String?,
          name: data['name'] as String?,
          year: data['year'] as String?,
          rollNo: data['rollNo'] as String?,
          branch: data['branch'] as String?,
          profileImageUrl: data['profileImageUrl'] as String?,
        );
      }).toList();
    } catch (e) {
      print("Error fetching all users: $e");
      return [];
    }
  }
}

