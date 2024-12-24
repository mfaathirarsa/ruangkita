import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:bcrypt/bcrypt.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  // Private constructor
  DatabaseHelper._init();

  // Getter for database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  // Initialize database
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Create tables
// Create tables
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      username TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      isAdmin INTEGER DEFAULT 0
    )
  ''');

    await db.execute('''
    CREATE TABLE content (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      type TEXT NOT NULL, -- "Article" atau "Video"
      imagePath TEXT,
      content TEXT,
      videoUrl TEXT,
      timestamp TEXT NOT NULL,
      likes INTEGER DEFAULT 0
    )
  ''');

    await db.execute('''
    CREATE TABLE user_likes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      contentId INTEGER NOT NULL,
      FOREIGN KEY (userId) REFERENCES users(id),
      FOREIGN KEY (contentId) REFERENCES content(id)
    )
  ''');

    await db.execute('''
    CREATE TABLE comments (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      contentId INTEGER NOT NULL,
      comment TEXT NOT NULL,
      timestamp TEXT NOT NULL,
      FOREIGN KEY (userId) REFERENCES users(id),
      FOREIGN KEY (contentId) REFERENCES content(id)
    )
  ''');

    // Tambahkan akun admin secara langsung
    final hashedPassword = _hashPassword('111111'); // Password admin
    await db.insert('users', {
      'name': 'Administrator',
      'email': 'admin@a.a',
      'username': 'admin',
      'password': hashedPassword,
      'isAdmin': 1, // Tandai sebagai admin
    });
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

  // FUNGSI KONTEN
  Future<List<Map<String, dynamic>>> fetchContentData() async {
    final db = await database;

    // Ambil semua data dari tabel content
    final List<Map<String, dynamic>> contentList = await db.query('content');

    // Konversi data ke format yang lengkap sesuai dengan database
    return contentList.map((content) {
      return {
        "id": content["id"], // ID konten
        "title": content["title"], // Judul konten
        "type": content["type"], // Tipe konten (Artikel/Video)
        "date": content["timestamp"]
            .split('T')[0], // Tanggal dengan format "YYYY-MM-DD"
        "imagePath": content["imagePath"], // Jalur gambar
        "content": content["content"], // Isi artikel
        "videoUrl": content["videoUrl"], // URL video
        "likes": content["likes"], // Jumlah like
      };
    }).toList();
  }

  Future<void> sendContentData(Map<String, dynamic> contentData) async {
    final db = await DatabaseHelper.instance.database;

    // Masukkan data ke dalam tabel 'content'
    await db.insert(
      'content',
      {
        'title': contentData["title"],
        'type': contentData["type"],
        'imagePath': contentData["imagePath"],
        'content': contentData["type"] == "Artikel"
            ? (contentData["content"] ?? "Isi artikel belum diatur.")
            : null,
        'videoUrl': contentData["type"] == "Video"
            ? (contentData["videoUrl"] ?? "URL video belum diatur.")
            : null,
        'timestamp': DateTime.now().toIso8601String(),
        'likes': 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Update jika konflik
    );
  }

  // Fungsi untuk menambahkan konten baru (hanya untuk admin)
  Future<int> addContent({
    required String title,
    required String type,
    required String? imagePath,
    required String? content,
    required String? videoUrl,
  }) async {
    final db = await database;

    // Validasi tipe konten
    if (type != 'Article' && type != 'Video') {
      throw Exception('Tipe konten tidak valid. Harus "Article" atau "Video".');
    }

    // Timestamp saat ini
    String timestamp = DateTime.now().toIso8601String();

    // Simpan data konten ke database
    return await db.insert('content', {
      'title': title,
      'type': type,
      'imagePath': imagePath,
      'content': content,
      'videoUrl': videoUrl,
      'timestamp': timestamp,
      'likes': 0,
    });
  }

// Fungsi untuk mendapatkan semua konten
  Future<List<Map<String, dynamic>>> getAllContent() async {
    final db = await database;
    return await db.query('content');
  }

// Fungsi untuk mendapatkan konten berdasarkan tipe (Article atau Video)
  Future<List<Map<String, dynamic>>> getContentByType(String type) async {
    final db = await database;
    return await db.query('content', where: 'type = ?', whereArgs: [type]);
  }

// Fungsi untuk mendapatkan konten berdasarkan ID
  Future<Map<String, dynamic>?> getContentById(int contentId) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'content',
      where: 'id = ?',
      whereArgs: [contentId],
    );

    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

// Fungsi untuk menambahkan like pada konten
  Future<void> likeContent(int userId, int contentId) async {
    final db = await database;

    // Periksa apakah user sudah memberikan like
    List<Map<String, dynamic>> existingLike = await db.query(
      'user_likes',
      where: 'userId = ? AND contentId = ?',
      whereArgs: [userId, contentId],
    );

    if (existingLike.isNotEmpty) {
      throw Exception('User sudah memberikan like pada konten ini.');
    }

    // Tambahkan like ke tabel user_likes
    await db.insert('user_likes', {'userId': userId, 'contentId': contentId});

    // Perbarui jumlah like pada konten
    await db.rawUpdate(
      'UPDATE content SET likes = likes + 1 WHERE id = ?',
      [contentId],
    );
  }

// Fungsi untuk menghapus like dari konten
  Future<void> unlikeContent(int userId, int contentId) async {
    final db = await database;

    // Hapus like dari tabel user_likes
    int rowsAffected = await db.delete(
      'user_likes',
      where: 'userId = ? AND contentId = ?',
      whereArgs: [userId, contentId],
    );

    if (rowsAffected == 0) {
      throw Exception('User belum memberikan like pada konten ini.');
    }

    // Kurangi jumlah like pada konten
    await db.rawUpdate(
      'UPDATE content SET likes = likes - 1 WHERE id = ?',
      [contentId],
    );
  }

// Fungsi untuk menambahkan komentar
  Future<int> addComment({
    required int userId,
    required int contentId,
    required String comment,
  }) async {
    final db = await database;

    // Timestamp saat ini
    String timestamp = DateTime.now().toIso8601String();

    return await db.insert('comments', {
      'userId': userId,
      'contentId': contentId,
      'comment': comment,
      'timestamp': timestamp,
    });
  }

// Fungsi untuk mendapatkan komentar berdasarkan konten
  Future<List<Map<String, dynamic>>> getCommentsByContent(int contentId) async {
    final db = await database;
    return await db
        .query('comments', where: 'contentId = ?', whereArgs: [contentId]);
  }

// Fungsi untuk mendapatkan komentar berdasarkan pengguna
  Future<List<Map<String, dynamic>>> getCommentsByUser(int userId) async {
    final db = await database;
    return await db.query('comments', where: 'userId = ?', whereArgs: [userId]);
  }

// Fungsi untuk menghapus konten (hanya untuk admin)
  Future<void> deleteContent(int contentId) async {
    final db = await database;

    // Hapus semua like dan komentar terkait konten
    await db
        .delete('user_likes', where: 'contentId = ?', whereArgs: [contentId]);
    await db.delete('comments', where: 'contentId = ?', whereArgs: [contentId]);

    // Hapus konten dari tabel content
    await db.delete('content', where: 'id = ?', whereArgs: [contentId]);
  }

  /// Menutup database (opsional)
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
