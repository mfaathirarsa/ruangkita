import 'package:flutter/material.dart';
import '../controller/database_controller.dart';
import 'profile_page_update.dart';
import 'profile_page_update_password.dart';

class ProfilePage extends StatefulWidget {
  final int userId; // ID pengguna yang login

  const ProfilePage({super.key, required this.userId});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final _dbHelper = DatabaseHelper();
  Map<String, dynamic>? _userData;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Fungsi untuk mengambil data pengguna berdasarkan userId
  void _loadUserData() async {
    try {
      var user = await _dbHelper.getUserById(widget.userId);
      setState(() {
        _userData = user;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Navigasi ke halaman update profil
  void _navigateToUpdateProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProfilePage(userId: widget.userId),
      ),
    ).then((_) => _loadUserData()); // Reload data setelah update
  }

  /// Navigasi ke halaman update password
  void _navigateToUpdatePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdatePasswordPage(userId: widget.userId),
      ),
    );
  }

  /// Fungsi logout dan arahkan ke halaman login
  void _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          // Tombol logout di bagian atas
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
              ? const Center(child: Text('Gagal memuat data pengguna'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama: ${_userData!['name']}',
                          style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('Username: ${_userData!['username']}',
                          style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('Email: ${_userData!['email']}',
                          style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _navigateToUpdateProfile,
                        child: const Text('Update Profil'),
                      ),
                      ElevatedButton(
                        onPressed: _navigateToUpdatePassword,
                        child: const Text('Update Password'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
