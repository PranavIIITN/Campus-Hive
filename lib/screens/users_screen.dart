import 'package:flutter/material.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/user_service.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      _users = await UserService().getAllUsers();
    } catch (e) {
      print("Error fetching users: $e");
      // Handle error appropriately, e.g., show an error message
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  title: Text(user.name ?? 'No Name'),
                  subtitle: Text(
                      'Roll No: ${user.rollNo ?? 'N/A'} | Year: ${user.year ?? 'N/A'}'),
                  // You can add more details or customize the ListTile as needed
                );
              },
            ),
    );
  }
}