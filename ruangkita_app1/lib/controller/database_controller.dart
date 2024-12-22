import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:bcrypt/bcrypt.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,        -- Nama lengkap
      email TEXT NOT NULL UNIQUE, -- Email harus unik
      username TEXT NOT NULL UNIQUE, -- Username harus unik
      password TEXT NOT NULL
    )
  ''');
  }

  /// Hash password menggunakan bcrypt
  String _hashPassword(String plainPassword) {
    return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
  }

  /// Verifikasi password dengan hash yang disimpan
  bool verifyPassword(String plainPassword, String hashedPassword) {
    return BCrypt.checkpw(plainPassword, hashedPassword);
  }

  /// Mendaftarkan pengguna baru
  Future<int> registerUser(
      String name, String email, String username, String password) async {
    try {
      final db = await database;

      // Cek apakah email atau username sudah ada
      List<Map<String, dynamic>> existingUser = await db.query(
        'users',
        where: 'email = ? OR username = ?',
        whereArgs: [email, username],
      );

      if (existingUser.isNotEmpty) {
        // Jika sudah ada, lempar exception sesuai dengan yang ditemukan
        if (existingUser.first['email'] == email) {
          throw Exception('Email sudah terdaftar');
        } else if (existingUser.first['username'] == username) {
          throw Exception('Username sudah terdaftar');
        }
      }

      // Hash password sebelum disimpan
      final hashedPassword = _hashPassword(password);

      // Simpan user baru ke database
      return await db.insert(
        'users',
        {
          'name': name,
          'email': email,
          'username': username,
          'password': hashedPassword,
        },
      );
    } catch (e) {
      print('Error registering user: $e');
      return -1; // Mengindikasikan error
    }
  }

  /// Login pengguna dengan validasi username dan password
  Future<Map<String, dynamic>?> loginUser(
      String username, String plainPassword) async {
    try {
      final db = await database;

      // Ambil data pengguna berdasarkan username
      List<Map<String, dynamic>> results = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );

      if (results.isNotEmpty) {
        final user = results.first;

        // Verifikasi password
        if (verifyPassword(plainPassword, user['password'])) {
          print('Login berhasil untuk user: $username');
          return user;
        } else {
          print('Password tidak cocok untuk user: $username');
        }
      } else {
        print('User tidak ditemukan: $username');
      }
    } catch (e) {
      print('Error logging in user: $e');
    }

    return null; // Login gagal
  }

  /// Cari pengguna berdasarkan email atau username
  Future<Map<String, dynamic>?> loginUserByEmailOrUsername(String input) async {
    try {
      final db = await database;

      // Query untuk mencari user berdasarkan email atau username
      List<Map<String, dynamic>> results = await db.query(
        'users',
        where: 'email = ? OR username = ?',
        whereArgs: [input, input],
      );

      if (results.isNotEmpty) {
        final user = results.first;
        print('Hasil query login: $user'); // Debugging
        return user;
      } else {
        print('User tidak ditemukan untuk input: $input');
      }
    } catch (e) {
      print('Error fetching user: $e');
    }

    return null;
  }

  /// Mendapatkan data pengguna berdasarkan ID
  Future<Map<String, dynamic>?> getUserById(int userId) async {
    try {
      final db = await database;
      List<Map<String, dynamic>> results = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (results.isNotEmpty) {
        return results.first;
      }
    } catch (e) {
      print('Error fetching user by ID: $e');
    }
    return null;
  }

  /// Memperbarui profil pengguna
  Future<void> updateUserProfile(
      int userId, String name, String email, String username) async {
    final db = await database;

    // Pastikan email dan username tetap unik
    List<Map<String, dynamic>> existingUsers = await db.query(
      'users',
      where: '(email = ? OR username = ?) AND id != ?',
      whereArgs: [email, username, userId],
    );

    if (existingUsers.isNotEmpty) {
      if (existingUsers.first['email'] == email) {
        throw Exception('Email sudah digunakan oleh pengguna lain');
      } else if (existingUsers.first['username'] == username) {
        throw Exception('Username sudah digunakan oleh pengguna lain');
      }
    }

    await db.update(
      'users',
      {'name': name, 'email': email, 'username': username},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  /// Memperbarui password pengguna
  Future<void> updateUserPassword(int userId, String newPassword) async {
    final db = await database;

    // Hash password baru sebelum disimpan
    final hashedPassword = _hashPassword(newPassword);

    await db.update(
      'users',
      {'password': hashedPassword},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  /// Menutup database (opsional)
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
