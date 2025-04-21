import 'package:flutter/material.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/user_service.dart';


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
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final user = await _userService.getUser(widget.userId);
      setState(() {
        _user = user;
      });
    } catch (e) {
      print("Profile screen: Error fetching user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body:
          _user == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: const AssetImage(
                          'assets/placeholder_image.png',
                        ), // Use a placeholder image
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
