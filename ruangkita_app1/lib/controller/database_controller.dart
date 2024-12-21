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
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  /// Hash password menggunakan bcrypt
  String _hashPassword(String plainPassword) {
    return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
  }

  /// Verifikasi password dengan hash yang disimpan
  bool _verifyPassword(String plainPassword, String hashedPassword) {
    return BCrypt.checkpw(plainPassword, hashedPassword);
  }

  /// Mendaftarkan pengguna baru
  Future<int> registerUser(String username, String password) async {
    try {
      final db = await database;

      // Hash password sebelum disimpan
      final hashedPassword = _hashPassword(password);

      return await db.insert(
        'users',
        {'username': username, 'password': hashedPassword},
      );
    } catch (e) {
      print('Error registering user: $e');
      return -1; // Mengindikasikan error
    }
  }

  /// Login pengguna dengan validasi username dan password
  Future<Map<String, dynamic>?> loginUser(String username, String plainPassword) async {
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
        if (_verifyPassword(plainPassword, user['password'])) {
          return user;
        }
      }
    } catch (e) {
      print('Error logging in user: $e');
    }

    return null; // Login gagal
  }

  /// Menutup database (opsional)
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
