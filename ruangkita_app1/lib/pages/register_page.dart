import 'package:flutter/material.dart';
import '../controller/database_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController =
      TextEditingController(); // Controller untuk username
  final _passwordController = TextEditingController();
  final _dbHelper = DatabaseHelper();

  bool _isLoading = false; // Indikator proses registrasi

  /// Fungsi untuk registrasi
  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Tampilkan loader
      });

      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();

      try {
        int id = await _dbHelper.registerUser(name, email, username, password);

        if (id > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registrasi berhasil')),
          );
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registrasi gagal')),
          );
        }
      } catch (e) {
        if (e.toString().contains('Email sudah terdaftar')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email sudah digunakan')),
          );
        } else if (e.toString().contains('Username sudah terdaftar')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Username sudah digunakan')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Terjadi error: $e')),
          );
        }
      } finally {
        setState(() {
          _isLoading = false; // Sembunyikan loader
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false, // Menghindari perubahan layout saat keyboard muncul
      // appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          // Agar seluruh form terpusat di tengah
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Menyusun konten di tengah vertikal
              children: [
                // Menambahkan judul "Register" di atas form
                const Text(
                  'Register',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20), // Spasi antara judul dan form

                // Kolom input untuk nama lengkap
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama lengkap tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16), // Spasi antar kolom

                // Kolom input untuk email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16), // Spasi antar kolom

                // Kolom input untuk username
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    if (value.length < 3) {
                      return 'Username harus minimal 3 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16), // Spasi antar kolom

                // Kolom input untuk password
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password harus minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16), // Spasi antar kolom

                // Loader atau tombol registrasi
                _isLoading
                    ? const CircularProgressIndicator() // Loader saat registrasi
                    : ElevatedButton(
                        onPressed: _register,
                        child: const Text('Register'),
                      ),
                const SizedBox(
                    height: 16), // Spasi antara tombol registrasi dan login

                // Tombol untuk menuju halaman login
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('Sudah punya akun? Login'),
                ),
                // const SizedBox(height: 60), // Spasi antar kolom
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
