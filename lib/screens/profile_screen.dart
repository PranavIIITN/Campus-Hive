import 'dart:io';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    print("Profile screen: User ID: ${widget.userId}");
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    _user = await _userService.getUser(widget.userId);
    setState(() {});
    print("User loaded: ${_user?.name}");
  }

  Future<void> _changeProfilePicture() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        print("Selected image path: ${pickedFile.path}");
        File imageFile = File(pickedFile.path);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm"),
              content: const Text("Do you want to update your profile picture?"),
              actions: <Widget>[
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("Update"),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _userService.uploadProfilePicture(widget.userId, imageFile);
                    _loadUserDetails();
                  },
                ),
              ],
            );
          },
        );
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error changing profile picture: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _changeProfilePicture,
                      child: _user!.profileImageUrl != null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(_user!.profileImageUrl!),
                            )
                          : const CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage('assets/placeholder_image.png'),
                            ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _user!.name ?? 'Name not available',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildDetailTile(
                      context,
                      Icons.email,
                      'Email',
                      _user!.email ?? 'Not specified',
                    ),
                    _buildDetailTile(
                      context,
                      Icons.school,
                      'Year',
                      _user!.year ?? 'Not specified',
                    ),
                    _buildDetailTile(
                      context,
                      Icons.format_list_numbered,
                      'Roll Number',
                      _user!.rollNo ?? 'Not specified',
                    ),
                    _buildDetailTile(
                      context,
                      Icons.account_balance,
                      'Branch',
                      _user!.branch ?? 'Not specified',
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDetailTile(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }
}
