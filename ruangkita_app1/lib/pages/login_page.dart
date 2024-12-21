import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import '../controller/database_controller.dart';
import '../controller/user_provider.dart'; // Provider untuk mengelola user data
import 'package:provider/provider.dart'; // Untuk mengakses Provider

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController =
      TextEditingController(); // Satu kolom untuk email/username
  final _passwordController = TextEditingController();
  final _dbHelper = DatabaseHelper();

  bool _isLoading = false; // Untuk menampilkan loader

  /// Validasi password plaintext dengan hash yang disimpan
  bool checkPassword(String plainPassword, String hashedPassword) {
    return BCrypt.checkpw(plainPassword, hashedPassword);
  }

  /// Fungsi untuk login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String loginInput = _loginController.text.trim();
      String password = _passwordController.text.trim();

      try {
        // Ambil user berdasarkan email atau username
        var user = await _dbHelper.loginUserByEmailOrUsername(loginInput);

        if (user != null) {
          // Pastikan id diambil dari hasil query
          final userId = user['id'] as int?;
          if (userId == null) {
            throw Exception('User ID tidak valid');
          }

          // Simpan userId ke SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          prefs.setInt('userId', userId);

          // Simpan ke UserProvider
          Provider.of<UserProvider>(context, listen: false).setUserId(userId);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login berhasil')),
          );

          // Navigasi ke dashboard
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Login gagal, periksa email/username dan password')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _loginController,
                decoration:
                    const InputDecoration(labelText: 'Email atau Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email atau Username tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator() // Loader saat login
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/register');
                },
                child: const Text('Belum punya akun? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
