// lib/screens/user_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lab08/lab9/api.dart';
import 'package:lab08/lab9/model.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final ApiService _apiService = ApiService();
  late Future<void> _initialDataFetch;
  List<User> _userList = [];

  @override
  void initState() {
    super.initState();
    _initialDataFetch = _fetchData();
  }

  // Fetch data from the API
  Future<void> _fetchData() async {
    try {
      final fetchedUsers = await _apiService.fetchUsers();
      setState(() {
        _userList = fetchedUsers;
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch data: $e');
    }
  }

  // Show dialog for adding or editing a user
  void _showUserDialog({User? user, bool isEditing = false}) {
    final TextEditingController nameController =
        TextEditingController(text: user?.name ?? '');
    final TextEditingController emailController =
        TextEditingController(text: user?.email ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit User' : 'Add User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final email = emailController.text.trim();

              if (name.isEmpty || email.isEmpty) {
                Get.snackbar('Error', 'Both fields are required');
                return;
              }

              Navigator.pop(context); // Close the dialog

              final newUser = User(
                // If editing, use existing ID; otherwise, use 0 for a new user
                id: isEditing ? user?.id ?? 0 : 0,
                name: name,
                email: email,
              );

              if (isEditing && user != null) {
                // Edit User
                try {
                  await _apiService.updateUser(newUser.id, newUser);
                  setState(() {
                    final index = _userList.indexWhere((u) => u.id == user.id);
                    if (index != -1) {
                      _userList[index] = newUser; // Update user in the list
                    }
                  });
                  Get.snackbar('Success', 'User updated successfully');
                } catch (e) {
                  Get.snackbar('Error', 'Failed to update user');
                }
              } else {
                // Create New User
                try {
                  final createdUser = await _apiService.createUser(newUser);
                  setState(() {
                    _userList.insert(0,
                        createdUser); // Add the newly created user to the list
                  });
                  Get.snackbar('Success', 'User added successfully');
                } catch (e) {
                  Get.snackbar('Error', 'Failed to add user');
                }
              }
            },
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: FutureBuilder<void>(
        future: _initialDataFetch,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: _userList.length,
              itemBuilder: (context, index) {
                final user = _userList[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showUserDialog(user: user, isEditing: true);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          try {
                            await _apiService.deleteUser(user.id);
                            setState(() {
                              _userList.removeAt(index);
                            });
                            Get.snackbar(
                                'Success', 'User deleted successfully');
                          } catch (e) {
                            Get.snackbar('Failed', 'Failed to delete user');
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
